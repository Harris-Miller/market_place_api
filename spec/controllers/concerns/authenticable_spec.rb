require 'rails_helper'

class Authentication
  include Authenticable

  def request
  end
end

RSpec.describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }
  # before do
  #   allow(authentication).to receive(:current_user).and_call_original
  # end

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      request.headers["Authorization"] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end
end