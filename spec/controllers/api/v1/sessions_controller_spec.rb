require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe "POST #create" do
    before(:each) { @user = FactoryGirl.create :user }

    context "when the credentials are correct" do
      before(:each) do
        credentials = { email: @user.email, password: "12345678" }
        post :create, { session: credentials }, format: :json
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        user_response = json_response
        expect(user_response).to have_key(:data)
        expect(user_response[:data]).to have_key(:attributes)
        expect(user_response[:data][:attributes][:"auth-token"]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context "when the credentials are incorrect" do
      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, { session: credentials }, format: :json
      end

      it("renders an errors json") { expect(json_response).to have_key(:errors) }

      it "returns a json with an error explaining why" do
        first_error = json_response[:errors][0]
        expect(first_error[:detail]).to include "Invalid email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destory" do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, id: @user.auth_token, format: :json
    end

    it { should respond_with 204 }
  end

end
