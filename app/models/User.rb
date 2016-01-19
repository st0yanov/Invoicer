require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  def password=(new_password)
    write_attribute(:password, Password.create(new_password))
  end
end
