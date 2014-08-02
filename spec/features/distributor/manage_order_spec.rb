require "spec_helper"

feature "Create an order for a customer", js: true do
  scenario "creates an order without extras" do
    @distributor = Fabricate(:distributor)
    simulate_distributor_sign_in

    customer = Fabricate(:customer, distributor: @distributor)
    Fabricate(:box, distributor: @distributor)

    visit distributor_customer_path(id: customer.id)
    click_link "Create a new order"
    expect(page).not_to have_content "Extras"
    click_button "Save"
    expect(page).to have_content "Order was successfully created"
  end

  scenario "creates an order with extras" do
    @distributor = Fabricate(:distributor_with_everything)
    simulate_distributor_sign_in

    customer = @distributor.customers.first

    visit distributor_customer_path(id: customer.id)
    click_link "Create a new order"
    expect(page).to have_content "Extras"
    click_button "Save"
    expect(page).to have_content "Order was successfully created"
  end
end
