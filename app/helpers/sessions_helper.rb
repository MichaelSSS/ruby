module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent.signed[:user_id] = user.id
  end
  
  def current_user
    if (id = session[:user_id])
      @user ||= User.find_by(id: id)
    elsif (id = cookies.signed[:user_id])
      user = User.find_by(id: id)
      if (user && user.authenticated?(cookies[:remember_token]))
        log_in user
        @user = user
      end
    end
  end
  
  def logged_in?
    ! current_user.nil?
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @user = nil
  end
  
  def current_user?(user)
    user.id = current_user.id
  end
  
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
  def redirect_back_or(default)
    redirect_to session[:forwarding_url] || default
    session.delete(:forwarding_url)
  end
  
end
