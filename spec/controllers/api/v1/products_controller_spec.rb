require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      get :index, format: :json
    end

    it("returns data") { expect(json_response).to have_key(:data) }

    it "returns 4 records from the database" do
      expect(json_response[:data].size).to eql 4
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id, format: :json
    end

    it("returns data") { expect(json_response).to have_key(:data) }

    it "returns the information about a reporter on a hash" do
      product_response = json_response[:data]
      expect(product_response).to have_key(:attributes)
      expect(product_response[:attributes][:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfuylly created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }, format: :json
      end

      it("returns data") { expect(json_response).to have_key(:data) }

      it "renders the json representation for the product record just created" do
        product_response = json_response[:data]
        expect(product_response).to have_key(:attributes)
        expect(product_response[:attributes][:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Smart TV", price: "Twelve dollars" }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }, format: :json
      end

      it("renders an errors json") { expect(json_response).to have_key(:errors) }

      it "renders the json errors on why the product could not be created" do
        first_error = json_response[:errors][0]
        expect(first_error[:title]).to eql "Invalid attribute 'price'"
        expect(first_error[:detail]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) { patch :update, { user_id: @user.id, id: @product.id, product: { title: "An expensive TV" } } }

      it("returns data") { expect(json_response).to have_key(:data) }

      it "renders the json representation for the updated user" do
        product_response = json_response[:data]
        expect(product_response).to have_key(:attributes)
        expect(product_response[:attributes][:title]).to eql "An expensive TV"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) { patch :update, { user_id: @user.id, id: @product.id, product: { price: "two hundred" } } }

      it("renders an errors json") { expect(json_response).to have_key(:errors) }

      it "renders the json errors on why the user could not be created" do
        first_error = json_response[:errors][0]
        expect(first_error[:title]).to eql "Invalid attribute 'price'"
        expect(first_error[:detail]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @product.id }
    end

    it { should respond_with 204 }
  end
end
