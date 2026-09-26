class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @posts = Post.includes(:user)
                 .upcoming
                 .by_game(params[:game_name])
                 .by_style(params[:style])

    @game_names = Post.distinct.pluck(:game_name)
    @styles = Post::STYLES
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: "募集を投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :title, :game_name, :event_at, :area, :meeting_place,
      :capacity, :style, :level, :description
    )
  end
end
