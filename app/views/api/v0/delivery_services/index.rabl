# app/views/api/v0/delivery_services/index.rabl
collection @delivery_services
attributes :id, :name, :fee_cents, :instructions
