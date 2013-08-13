class SessionsController < ApplicationController
  def new
  end
  
  def create
    usr = User.find_by_email(params[:session][:email].downcase)
    if(usr && usr.authenticate(params[:session][:password]))
      sign_in usr
      redirect_to usr
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
