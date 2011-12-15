module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end
  

  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end

  # add to insure that the user can only edit the user
  def right_user?(user)
     return  current_user == user
  end

   
  def deny_access
    storedirectpath
    redirect_to signin_path,:notice =>"need to signin first with the correct user"    
  end 
  
  def redirect_back_or(default)
     redirect_to(session[:back_to] || default)
     cleardirectpath
  end

  private
     
    

    def storedirectpath
       session[:back_to] = request.fullpath
    end

    def cleardirectpath
       session[:back_to] = nil
    end

    
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end


end
