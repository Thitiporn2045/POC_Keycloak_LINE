class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = session[:user] # ใช้งานข้อมูลตรงนี้ได้เลย
  end

  private

  def authenticate_user!
    redirect_to login_path unless session[:user].present?
  end
end
