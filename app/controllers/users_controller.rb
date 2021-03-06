class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :following, :followers, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :not_signed_in_user, only: [:new, :create]
  before_filter :admin_user, only: [:destroy]
  
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def destroy
    user_to_delete = User.find(params[:id])
    if(!user_to_delete.admin?)
      
      user_to_delete.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    else
      flash[:error] = "Admins cannot destroy themselves"
      redirect_to users_url
    end
  end
  
  def create
    @user = User.new(params[:user])
    if(@user.save)
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private



  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  def not_signed_in_user
    redirect_to(root_url) if signed_in?
  end
    
end
  

