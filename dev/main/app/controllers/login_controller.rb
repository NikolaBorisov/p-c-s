class LoginController < ApplicationController
  
  before_filter :authorize, :except => [:login, :signup, :register]
  before_filter :authorize_admin, :only => [:admin]
  
  def signup
    logged_in_user = PCS::Model::User.authenticate(params[:user][:username],params[:user][:password])
    if logged_in_user
      session[:user_id] = logged_in_user.user_id
      logged_in_user.roles.each do |role|
        session[role.name.to_sym] = true
      end
      
      redirect_to(:action => 'index')
    else
      info("Wrong username or password.", "error")
      redirect_message(:action => "login")
    end
    
  end
  
  def login
    session[:user_id] = nil
    session[:admin] = nil
    session[:contestant] = nil
    @user = PCS::Model::User.new
  end
  
  def register
    if (request.get?)
      @user = PCS::Model::User.new
    else
      @user = PCS::Model::User.new(params[:user])
      @user.roles << PCS::Model::Role.find_by_name("contestant")
      if @user.save
        info("User #{@user.username} registered succesfull")
        redirect_message(:action => 'login')      
      end
    end
  end
  
  def index
    @roles = PCS::Model::Role.find(:all)
  end
  
  def admin     
  end
  
  def contestant
    redirect_to(:controller => "contestant/contest", :action => "list")
  end
  
  
end
