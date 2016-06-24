require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      get :index, format: :json
    end

    it "returns 4 records from the database" do
      products_response = json_response
      expect(products_response[:products]).to have(4).items
    end

    it { should respond_with 200 }
  end
  
  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end
end