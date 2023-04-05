class PostsController < ApplicationController



  def index
    @posts = Post.order(created_at: :desc)
    @post = Post.all
  end


  def new
  end 

  def show 
    @post = Post.find(params[:id])
  end 


  def create
      Post.create(post_params)

      redirect_to root_path
  end

  def edit
     @post = Post.find_by_id(params[:id])
  end

  def update

     @post = Post.find_by_id(params[:id])

    if @post.update(post_params)
      redirect_to friends_url, notice: "User can successfuly updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end



  private

  def post_params
    params.require(:post).permit(:description, :profile_image, :friend_id)
  end

end
