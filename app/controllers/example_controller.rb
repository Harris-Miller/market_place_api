class ExampleController < ApplicationController
  def show
    respond_with User.find(params[:id])
  end
end
