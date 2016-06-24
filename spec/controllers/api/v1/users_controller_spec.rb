require 'rails_helper'

describe Api::V1::UsersController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it("returns data") { expect(json_response).to have_key(:data) }

    it "returns the information about the reporter on a hash" do
      user_response = json_response[:data]
      expect(user_response).to have_key(:attributes)
      expect(user_response[:attributes][:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it("returns data") { expect(json_response).to have_key(:data) }

      it "renders the json representation for the user record just created" do
        user_response = json_response[:data]
        expect(user_response).to have_key(:attributes)
        expect(user_response[:attributes][:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        # email is purposely excluded
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it("renders an errors json") { expect(json_response).to have_key(:errors) }

      it "renders the json errors on why the user could not be created" do
        first_error = json_response[:errors][0]
        expect(first_error[:title]).to eql "Invalid attribute 'email'"
        expect(first_error[:detail]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "newmail@example.com" } }, format: :json
      end

      it("returns data") { expect(json_response).to have_key(:data) }

      it "renders the json represntation for the updated user" do
        user_response = json_response[:data]
        expect(user_response).to have_key(:attributes)
        expect(user_response[:attributes][:email]).to eql "newmail@example.com"
      end

      it { should respond_with 200 }
    end

    context "when is not created" do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "bademail.com" } }, format: :json
      end

      it("renders an errors json") { expect(json_response).to have_key(:errors) }

      it "renders the json errors on why the user could not be created" do
        first_error = json_response[:errors][0]
        expect(first_error[:title]).to eql "Invalid attribute 'email'"
        expect(first_error[:detail]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, { id: @user.id }, format: :json
    end

    it { should respond_with 204 }
  end
end
