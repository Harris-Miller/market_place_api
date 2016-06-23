require 'spec_helper'

describe ExampleController do
  describe "GET #show" do
    it "should respond with a 200" do
      get :show
      should respond_with 200
    end
  end
end
