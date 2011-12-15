class UsersController < ApplicationController
  before_filter :authenticate,:only=>[:edit,:update]
  before_filter :correctuser,:only=>[:edit,:update]
  def show
    @user = User.find(params[:id])
    @title = "SHow lionel's user"
  end

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end


  def edit
    @user = User.find(params[:id])
    @title = "EDIT USER"
  end

  def update
    @user = User.find(params[:id]);
    if @user.update_attributes(params[:user])
       flash[:success] = "update user completed"
       redirect_to @user
    else
       
       render 'edit'
    end 
    #redirect_to root_path
  end 
  
  private
    def correctuser
       @user = User.find(params[:id])
       deny_access unless right_user? @user
    end
    def authenticate
        deny_access unless signed_in?
    end

end
