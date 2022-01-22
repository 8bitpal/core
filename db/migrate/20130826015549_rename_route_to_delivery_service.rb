class RenameRouteToDeliveryService < ActiveRecord::Migration[7.0]
  def change
    rename_index :route_schedule_transactions,              :index_route_schedule_transactions_on_route_id, :index_delivery_service_schedule_transactions_on_ds_id # max index length is 63 hence the "ds"
    #rename_index :customers,                                :index_customers_on_route_id,                   :index_customers_on_delivery_service_id
    #rename_index :deliveries,                               :index_deliveries_on_route_id,                  :index_deliveries_on_delivery_service_id
    #rename_index :route_schedule_transactions,              :route_schedule_transactions_pkey,              :delivery_service_schedule_transactions_pkey
    #rename_index :routes,                                   :routes_pkey,                                   :delivery_services_pkey
    #rename_index :routes,                                   :index_routes_on_distributor_id,                :index_delivery_services_on_distributor_id
    rename_column :customers,                               :route_id,                                      :delivery_service_id
    rename_column :deliveries,                              :route_id,                                      :delivery_service_id
    rename_column :delivery_sequence_orders,                :route_id,                                      :delivery_service_id
    rename_column :packages,                                :archived_route_fee_cents,                      :archived_delivery_service_fee_cents
    rename_table :route_schedule_transactions,              :delivery_service_schedule_transactions
    rename_column :delivery_service_schedule_transactions,  :route_id, :delivery_service_id
    rename_table :routes,                                   :delivery_services
  end
end
