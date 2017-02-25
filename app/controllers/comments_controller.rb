class CommentsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :new, :destroy]


  def new
    @comment = Comment.new
  end

  def create
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new comment_params
    @comment.user = current_user
    @post = Post.find params[:post_id]
    @comment.post = @post
    # redirect_to root_path, alert: "access defined" unless can? :create, @comment

    if @comment.save
      redirect_to post_path(@post)

    else
      flash.now[:alert] = "please fix errors"
      render 'posts/show'
    end
  end

  def edit
    # @post = Post.find params[:id]
    # render json: params
    @comment = Comment.find params[:post_id]
  end

  def destroy
    @comment = Comment.find params[:post_id]
    @user = User.find @comment.user_id


    if current_user.id == @comment.user_id || current_user.is_admin == true
      @comment.destroy
      redirect_to post_path(@comment.post_id), notice: 'Comment deleted!'
    else
      redirect_to post_path(@comment.post_id), alert: "access denied" unless can? :destroy, @comment
    end

  end

end