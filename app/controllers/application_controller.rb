class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protected
  def build_errors_hash(errors)
    { errors: errors.collect {|key, value| { title: "Invalid attribute '#{key.to_s}'", detail: value } } }
  end

  private

  def record_not_found(error)
    render json: { errors: [{ title: "Not Found", detail: error.message }] }, status: 404
  end
end
