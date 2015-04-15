class Customer::OrdersController < Customer::ResourceController
  actions :edit, :update

  respond_to :html, :json

  before_filter :filter_params, only: [:update]
  before_filter :get_order, only: [:pause, :remove_pause, :resume, :remove_resume, :pause_dates, :resume_dates]

  def edit
    edit! do
      load_form
    end
  end

  def update
    @order = current_customer.orders.find(params[:id])

    unless @order.customer_can_edit?
      redirect_to customer_root_path, alert: t('c.order.update.not_allowed') and return
    end

    # keep references to old values for create_activities_from_changes
    @old_box = @order.box
    @old_order_extras = @order.order_extras.dup

    update! do |success, failure|
      success.html do
        create_activities_from_changes
        flash[:notice] = t('c.order.update.success')
        redirect_to customer_root_url
      end

      failure.html do
        load_form
        flash[:error] = t('c.order.update.oops')
        render 'edit'
      end
    end
  end

  def pause
    start_date = Date.parse(params[:date])

    @order.pause!(start_date, @order.resume_date)
    @order.customer.add_activity(:order_pause, order: @order)
    render partial: 'customer/orders/details', locals: { order: @order }
  end

  def remove_pause
    @order.remove_pause!
    @order.customer.add_activity(:order_remove_pause, order: @order)
    render partial: 'customer/orders/details', locals: { order: @order }
  end

  def pause_dates
    render json: @order.possible_pause_dates
  end

  def resume
    start_date = @order.pause_date
    end_date   = Date.parse(params[:date])

    @order.pause!(start_date, end_date)
    @order.customer.add_activity(:order_resume, order: @order)
    render partial: 'customer/orders/details', locals: { order: @order }
  end

  def remove_resume
    start_date = @order.pause_date

    @order.pause!(start_date)
    @order.customer.add_activity(:order_remove_resume, order: @order)
    render partial: 'customer/orders/details', locals: { order: @order }
  end

  def deactivate
    @order = current_customer.orders.find(params[:id])

    respond_to do |format|
      if !current_customer.can_deactivate_orders?
        format.html { redirect_to customer_root_path, notice: t('c.order.deactivate.not_allowed') }

      elsif !@order.recurs? && @order.has_yellow_deliveries?
        format.html { redirect_to customer_root_path, alert: t('c.order.deactivate.too_late.one_off') }

      elsif current_customer.can_deactivate_orders? && @order.update_attribute(:active, false)
        @order.customer.add_activity(:order_remove, order: @order)

        format.html do
          if @order.recurs? && @order.has_yellow_deliveries?
            flash[:alert] = t('c.order.deactivate.too_late.recurring')
          else
            flash[:notice] = t('c.order.deactivate.success')
          end
          redirect_to customer_root_path
        end
      else
        format.html { redirect_to customer_root_path, warning: t('c.order.deactivate.oops') }
      end
    end
  end

protected

  def collection
    @orders ||= end_of_association_chain.active
  end

private

  def filter_params
    params[:order] = params[:order].slice!(:include_extras)
  end

  def get_order
    @order = Order.find(params[:id])
  end

  def load_form
    @customer         = current_customer
    @distributor      = current_customer.distributor
    @account          = @customer.account
    @delivery_service = @customer.delivery_service
    @stock_list       = @distributor.line_items
    @form_params      = [:customer, @order]
    @dislikes_list    = @order.exclusions.map { |e| e.line_item_id.to_s }
    @likes_list       = @order.substitutions.map { |s| s.line_item_id.to_s }
  end

  def create_activities_from_changes
    if @old_box != @order.reload.box
      @order.customer.add_activity(:order_update_box, order: @order, old_box_name: @old_box.name)
    end

    new_order_extras = @order.reload.order_extras
    if @old_order_extras.present? && new_order_extras.empty?
      @order.customer.add_activity(:order_remove_extras, order: @order)
    elsif @old_order_extras.empty? && new_order_extras.present?
      @order.customer.add_activity(:order_add_extras, order: @order)
    elsif @old_order_extras != new_order_extras
      @order.customer.add_activity(:order_update_extras, order: @order)
    end
  end
end
