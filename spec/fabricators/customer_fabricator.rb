Fabricator(:customer) do
  distributor { Fabricate(:distributor_with_information) }
  delivery_service { |attrs| Fabricate(:delivery_service, distributor: attrs[:distributor]) }
  first_name { sequence(:first_name) { |i| "First Name #{i}" } }
  email { sequence(:email) { |i| "customer#{i}@example.com" } }
  password 'password'
  password_confirmation { |attrs| attrs[:password] }

  after_build do |customer|
    Fabricate(:address, customer: customer)
  end
end

Fabricator(:customer_with_transaction, from: :customer) do
  after_build do |customer|
    Fabricate(:transaction, account: customer.account)
  end
end

Fabricator(:customer_with_address, class_name: :customer) do
  distributor { Fabricate(:distributor_with_information) }
  delivery_service { |attrs| Fabricate(:delivery_service, distributor: attrs[:distributor]) }
  first_name { sequence(:first_name) { |i| "First Name #{i}" } }
  email { sequence(:email) { |i| "customer#{i}@example.com" } }
  password 'password'
  password_confirmation { |attrs| attrs[:password] }

  after_build do |customer|
    Fabricate(:full_address, customer: customer)
  end
end
