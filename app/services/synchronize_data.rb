class SynchronizeData
  attr_accessor :data

  def initialize data
    @data = begin
      JSON.parse(data)
    rescue JSON.ParserError
      nil
    end
  end

  def valid?
    data.is_a? Array
  end

  def save!
    @data.each do |user|
      member = User.find_by email: user["email"]
      next if member
      pass = Devise.friendly_token(16)
      User.create!(name: user["display_name"], email: user["email"],
        password: pass, password_confirmation: pass)
    end
  end
end
