class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def new
    @application = @post.applications.new
  end

  def create
    @application = @post.applications.new(application_params)
    @application.user = current_user

    if @application.save
      redirect_to post_path(@post), notice: "応募しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def application_params
    params.require(:application).permit(:comment)
  end
end
