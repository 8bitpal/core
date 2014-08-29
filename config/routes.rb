API_SUBDOMAIN = { subdomain: /\A(staging-)?api\Z/ } unless defined? API_SUBDOMAIN

BuckyBox::Application.routes.draw do
  apipie

  devise_for :admins,       controllers: { sessions: 'admin/sessions' }
  devise_for :distributors, controllers: { sessions: 'distributor/sessions', passwords: 'distributor/passwords' }
  devise_for :customers,    controllers: { sessions: 'customer/sessions', passwords: 'customer/passwords' }

  match "/delayed_job" => DelayedJobWeb, anchor: false
  match '/' => 'api#index', constraints: API_SUBDOMAIN

  root to: 'distributor/customers#index'

  get "/directory" => "directory#index"

  namespace :sign_up_wizard do
    get 'form'
    get 'country'
    post 'sign_up'
  end

  namespace :webstore, path: 'webstore/:distributor_parameter_name' do
    scope module: :store do
      get   '/',                            action: 'store',           as: 'store'
      match '/start_checkout/:product_id',  action: 'start_checkout',  as: 'start_checkout'
      get   '/completed',                   action: 'completed',       as: 'completed'
    end

    scope module: :customise_order do
      get  '/customise_order',  action: 'customise_order',           as: 'customise_order'
      post '/customise_order',  action: 'save_order_customisation',  as: 'customise_orders'
    end

    scope module: :authentication do
      get  '/authentication',  action: 'authentication',       as: 'authentication'
      post '/authentication',  action: 'save_authentication',  as: 'authentications'
    end

    scope module: :delivery_options do
      get  '/delivery_options',  action: 'delivery_options',       as: 'delivery_options'
      post '/delivery_options',  action: 'save_delivery_options',  as: 'delivery_options_index'
    end

    scope module: :payment_options do
      get  '/payment_options',  action: 'payment_options',       as: 'payment_options'
      post '/payment_options',  action: 'save_payment_options',  as: 'payment_options_index'
    end
  end

  namespace :distributor do
    root to: 'welcome#index'

    namespace :settings do
      get 'organisation'
      get 'webstore'
      post 'webstore', action: 'save_webstore'
      post 'spend_limit_confirmation'

      resource :delivery_services, only: [:show, :create, :update, :destroy]

      namespace :products do
        resource :boxes, only: [:show, :create, :update]
        resource :box_items, only: [:show, :create, :update]
        resource :extra_items, only: [:show, :create, :update]
      end

      namespace :payments do
        resource :bank_deposit, controller: "bank_deposit", only: [:show, :update]
        resource :cash_on_delivery, controller: "cash_on_delivery", only: [:show, :update]
        resource :paypal, controller: "paypal", only: [:show, :update]
      end
    end

    namespace :notifications do
      post 'dismiss_all', actions: 'dismiss_all', as: 'dismiss_all'
    end

    namespace :intro_tour do
      post 'dismiss', actions: 'dismiss', as: 'dismiss'
    end

    namespace :reports do
      get '/',                               action: 'index'
      get 'transaction_history/:start/:to',  action: 'transaction_history',      as: 'transaction_history'
      get 'customer_account_history/:to',    action: :customer_account_history,  as: 'customer_account_history'
    end

    resources :distributors,        only: :update
    resource  :bank_information,    only: :update
    resource  :invoice_information, only: [:create, :update]
    resources :boxes,               except: [:index]
    resources :extras,              except: [:index, :show]

    resources :line_items, except: [:index, :show, :update] do
      collection do
        put 'bulk_update', action: :bulk_update, as: 'bulk_update'
      end
    end

    resources :deliveries do
      collection do
        get 'date/:date/view/:view',  action: :index,                as: 'date'
        post 'date/:date/reposition', action: :reposition,           as: 'reposition'
        post 'update_status',         action: :update_status,        as: 'update_status'
        post 'make_payment',          action: :make_payment,         as: 'make_payment'
        post 'master_packing_sheet',  action: :master_packing_sheet, as: 'master_packing_sheet'
        post 'export',                action: :export,               as: 'export'
        post 'export_extras',         action: :export_extras,        as: 'export_extras'
        post 'export_exclusions_substitutions', action: :export_exclusions_substitutions, as: 'export_exclusions_substitutions'
      end
    end

    resources :invoices do
      collection do
        get 'to_send',  action: 'to_send', as: 'to_send'
        post 'do_send', action: 'do_send', as: 'do_send'
      end
    end

    resources :payments, only: [:create, :index, :show, :destroy] do
      collection do
        get 'upload_transactions', action: 'upload_transactions', as: 'upload_transactions'
        post 'commit_upload',      action: 'commit_upload',       as: 'commit_upload'
        post 'create_from_csv',    action: 'create_from_csv',     as: 'create_from_csv'
        post 'process_upload',     action: 'process_upload',      as: 'process_upload'
        post 'index',              action: 'match_payments',      as: 'match_payments'
      end

      member do
        put 'process_payments', action: 'process_payments', as: 'process_payments'
      end
    end

    resources :import_transactions, only: [:update] do
      member do
        get 'load_more_rows/:position', action: 'load_more_rows', as: 'load_more_rows'
      end
    end

    resources :import_transaction_lists, only: [:destroy]

    resources :customers, except: [ :edit ] do
      collection do
        get 'search',   action: :index, as: 'search'
        get 'tag/:tag', action: :index, as: 'tag'
        post 'email'
        post 'export'
      end

      member do
        get :send_login_details
        get 'impersonate'
        get 'activity'
        get 'edit_profile',             action: 'edit_profile',             as: 'edit_profile'
        put 'update_profile',           action: 'update_profile',           as: 'update_profile'
        get 'edit_delivery_details',    action: 'edit_delivery_details',    as: 'edit_delivery_details'
        put 'update_delivery_details',  action: 'update_delivery_details',  as: 'update_delivery_details'
      end
    end

    resources :accounts, only: :edit do
      resources :orders, except: [ :index, :show, :destroy ] do
        member do
          put 'deactivate'
          put 'pause'
          post 'remove_pause'
          put 'resume'
          post 'remove_resume'
        end
      end

      resources :boxes do
        member do
          get 'extras'
        end
      end

      member do
        put 'change_balance', action: :change_balance, as: 'change_balance'
        get 'transactions/:limit(/:more)', action: :transactions, as: 'transactions'
        get 'receive_payment', action: :receive_payment, as: 'receive_payment'
        post 'save_payment',   action: :save_payment, as: 'save_payment'
      end
    end
  end

  namespace :customer do
    root to: 'dashboard#index'

    get 'dashboard',               controller: 'dashboard', action: 'index'
    get 'order/:order_id/box/:id', controller: 'dashboard', action: 'box'

    put 'update_contact_details',   controller: 'customers',  action: 'update_contact_details'
    put 'update_delivery_address',  controller: 'customers',  action: 'update_delivery_address'
    put 'update_password',          controller: 'customers',  action: 'update_password'

    resources :boxes, only: [:show] do
      member do
        get 'extras'
      end
    end

    resources :orders, only: [:edit, :update] do
      member do
        put 'pause'
        post 'remove_pause'
        put 'resume'
        post 'remove_resume'
        put 'deactivate'
      end
    end

    resources :accounts, only:[] do
      get 'transactions/:limit(/:more)', action: :transactions, as: 'transactions'
    end
  end

  namespace :admin do
    root to: 'dashboard#index'

    resources :cron_logs, only: :index
    resources :style_sheet, only: :index

    resources :distributors do
      member do
        get 'impersonate'
        get 'customer_import'
        put 'validate_customer_import'
        post 'customer_import_upload'
      end

      collection do
        get 'unimpersonate'
        get 'country_setting/:id', controller: 'distributors', action: 'country_setting'
        get 'tag/:tag', action: :index, as: 'tag'
      end
    end

    resources :omni_importers do
      member do
        post 'test'
      end
    end
  end

  namespace :api, path: "", defaults: { format: :json }, constraints: API_SUBDOMAIN do
    namespace :v0 do
      resources :customers
      resources :orders
      resources :delivery_services
      resources :boxes
    end
  end

end
