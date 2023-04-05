class FriendsController < ApplicationController
  before_action :set_friend, only: [ :show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]


  def index
    # @friends = Friend.all.page(params[:page])
    @q = Friend.ransack(params[:q])
    @friends = @q.result.includes(:user).page(params[:page])
    # @friend = Kaminari.paginate_array(@friend).page(params[:page]).per(5)
  end

  def show  
    @friend = Friend.find(params[:id])

  end

  def new 
    @friend = current_user.friends.build
  end

  def create
    @friend = current_user.friends.build(friend_params)
    respond_to do |format|
      if @friend.save
        # current_user.add_role :creater,@friend
        FriendCleanupJob.set(wait: 20.seconds).perform_later(@friend)
        format.html { redirect_to friend_url(@friend), notice: "Friend was successfully created." }
        format.json { render :show, status: :created, location: @friend }
        
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  def acceptable_image 
   return unless profile_image.attached?
  end

  def edit
  end

  def update
    respond_to do |format|
      if @friend.update(friend_params)
         # current_user.add_role :editor,@friend
        FriendCleanupJob.set(wait: 5.seconds).perform_later(@friend)
      # CrudNotificationMailer.update_notification(@friend).deliver_now

        format.html { redirect_to friend_url(@friend), notice: "Friend was successfully updated." }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    CrudNotificationMailer.delete_notification(@friend).deliver_now
    @friend = Friend.find(params[:id])
    @friend.destroy
    FriendCleanupJob.set(wait: 5.seconds).perform_later(@friend)


    respond_to do |format|
      format.html { redirect_to friends_url, notice: "Friend was successfully destroyed." }
      format.json { head :no_content }
    end

      # redirect_to friend_path, status: :see_other

  end

  def correct_user
    @user = current_user.friends.find_by(id: params[:id])
    redirect_to friends_path, notice: "Not authorized this friend" if @friend.nil?
  end

  private
    def set_friend
      @friend = Friend.find(params[:id])
    end

    def friend_params
      params.require(:friend).permit(:first_name, :last_name, :email, :phone, :twitter, :instagram, :user_id, :profile_image )
    end
end

