module AuthHelpers
  def authorized?
    not session[:user].nil?
  end

  def logout!
    session.clear
  end
end
