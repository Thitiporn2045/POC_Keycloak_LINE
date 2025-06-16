# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  include KeycloaksHelper  # 👈 เพื่อเรียกใช้ get_token, get_user_info, logout_keycloak

  def login
    state = SecureRandom.hex(10)
    session[:state] = state

    redirect_to "#{ENV['KEYCLOAK_URL']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/auth" \
      "?client_id=#{ENV['KEYCLOAK_CLIENT_ID']}" \
      "&response_type=code" \
      "&scope=openid profile" \
      "&redirect_uri=#{ENV['KEYCLOAK_REDIRECT_URI']}" \
      "&state=#{state}", allow_other_host: true
  end

  def callback
    if params[:state] != session.delete(:state)
      render plain: "Invalid state", status: :unauthorized and return
    end

    # 👇 เรียกใช้ method จาก helper
    token = get_token(params[:code])
    access_token = token["access_token"]
    refresh_token = token["refresh_token"]

    user_info = get_user_info(access_token)


    # 👇 เก็บข้อมูลใน session
    session[:user] = {
      # email: user_info["email"],
      name: user_info["name"],
      # sub: user_info["sub"]
    }
    session[:refresh_token] = refresh_token

    redirect_to root_path
  end

  def logout
    # 👇 เรียกใช้ helper
    logout_keycloak(session[:refresh_token])
    reset_session
    redirect_to root_path
  end
end
