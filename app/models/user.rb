require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  validates :username, :password, presence: {
    message: I18n.t('validation.presence')
  }

  validates :username, length: {
    in: 4..32,
    too_short: I18n.t('validation.username.too_short'),
    too_long: I18n.t('validation.username.too_long')
  }

  validates :username, uniqueness: {
    case_sensitive: false,
    message: I18n.t('validation.username.uniqueness')
  }

  validates :password, length: {
    in: 5..64,
    too_short: I18n.t('validation.password.too_short'),
    too_long: I18n.t('validation.password.too_long')
  }

  def password=(new_password)
    write_attribute(:password, Password.create(new_password))
  end

  def check_password(input_password)
    Password.new(password) == input_password
  end
end
