class FriendsController < ApplicationController
  before_action :set_friend, only: [ :show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /friends or /friends.json
  def index
    @friends = Friend.all
  end

  # GET /friends/1 or /friends/1.json
  def show

  end

  # GET /friends/new
  def new
    #@friend = Friend.new
    @friend = current_user.friends.build

  end


  # POST /friends or /friends.json
  def create
    # @friend = Friend.new(friend_params)

    @friend = current_user.friends.build(friend_params)
    
    respond_to do |format|
      if @friend.save
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

  # GET /friends/1/edit
  def edit

  end

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
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

  # DELETE /friends/1 or /friends/1.json
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
    @friend = current_user.friends.find_by(id: params[:id])
    redirect_to friends_path, notice: "Not authorized this friend" if @friend.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friend_params
      params.require(:friend).permit(:first_name, :last_name, :email, :phone, :twitter, :instagram, :user_id, :profile_image )
    end
end

