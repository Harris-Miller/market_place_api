require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  before(:each) do
    current_user = FactoryGirl.create :user
    api_authorization_header current_user.auth_token
    4.times { FactoryGirl.create :order, user: current_user }
    get :index, user_id: current_user.id, format: :json
  end

  it "returns 4 order records from the user" do
    order_response = json_response

    expect(order_response).to have_key(:data)
    expect(order_response[:data].size).to eql(4)
  end

  it { should respond_with 200 }
end
