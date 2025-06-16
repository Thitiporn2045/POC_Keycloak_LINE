# app/helpers/keycloaks_helper.rb
require "net/http"
require "uri"
require "json"

module KeycloakHelper
  def get_token(code)
    uri = URI("#{ENV['KEYCLOAK_URL']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/token")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      grant_type: "authorization_code",
      code: code,
      redirect_uri: ENV['KEYCLOAK_REDIRECT_URI'],
      client_id: ENV['KEYCLOAK_CLIENT_ID'],
      client_secret: ENV['KEYCLOAK_CLIENT_SECRET']
    )

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def get_user_info(access_token)
    uri = URI("#{ENV['KEYCLOAK_URL']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/userinfo")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def logout_keycloak(refresh_token)
    uri = URI("#{ENV['KEYCLOAK_URL']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/logout")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      client_id: ENV['KEYCLOAK_CLIENT_ID'],
      client_secret: ENV['KEYCLOAK_CLIENT_SECRET'],
      refresh_token: refresh_token
    )

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
  end
end
