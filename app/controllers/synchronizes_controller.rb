class SynchronizesController < ApplicationController
  require "net/http"
  before_action :verity_admin?

  def index
    @has_token = current_user.hr_token.present?
  end

  def create
    response = load_data current_user.hr_email, current_user.hr_token
    if response.is_a? Net::HTTPSuccess
      sync_data = SynchronizeData.new response.body
      if sync_data.valid?
        sync_data.save!
        redirect_to synchronizes_path, notice: flash_message("synchronized")
        return
      end
    end
    token = get_token["token"]
    message = get_token["message"]
    if token.nil?
      redirect_to synchronizes_path, alert: message
    else
      current_user.update_attributes hr_token: token, hr_email: params[:email]
      redirect_to synchronizes_path, notice: flash_message("login_success")
    end
  end

  private
  def get_token
    email = params[:email]
    password = params[:password]
    uri = URI("#{Settings.hr_system_link.
      sessions}email=#{email}&password=#{password}")
    request = Net::HTTP::Post.new(uri)
    response = Net::HTTP.start(uri.host, uri.port){|http| http.request(request)}
    JSON(response.body)
  end

  def load_data email, token
    uri = URI("#{Settings.hr_system_link.users}email=#{email}&token=#{token}")
    Net::HTTP.get_response uri
  end
end
