class UsersController < ApplicationController

  def index
    # @users = User.all
    @users = User.includes(:friends)
    @users = User.all.page(params[:page])
    

    # @q = User.ransack(params[:q])
    # @users = @q.result.includes(:user).page(params[:page])
  end

  def show
    @user = User.find_by_id(params[:id])
    @friends = User.order(:user).page params[:page]
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  #this is for direct search without gem

  # def search
  #   if params[:search].blank?
  #     redirect_to root_path
  #   else 
  #     @parameter = params[:search].downcase
  #     @matchUsers= User.where("lower(email) LIKE ?", "%#{@parameter}%")
  #     @matchFriends = Friend.all.where("lower(first_name) LIKE ? or last_name LIKE ?", "%#{@parameter}%","%#{@parameter}%")
  #   end
  # end 

  def acceptable_image 
   return unless image.attached?
  end


  def correct_user
    @user = current_user.friends.find_by(id: params[:id])
    redirect_to friends_path, notice: "Not authorized this friend" if @friend.nil?
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
     params.require(:user).permit({role_ids: []}) 
  end
end




