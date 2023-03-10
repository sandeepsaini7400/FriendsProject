class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def acceptable_image 
   return unless profile_image.attached?
  end

  def update
    @user = User.find_by_id(params[:id])

    if @user.update(user_params)
      redirect_to users_url, notice: "User can successfuly updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private 
  def user_params
     params.require(:user).permit({role_id: []}) 
  end
end




