class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_organizer!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user)
                 .upcoming
                 .by_game(params[:game_name])
                 .by_style(params[:style])

    @game_names = Post.distinct.pluck(:game_name)
    @styles = Post::STYLES
  end

  def show
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

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "募集を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @post.status == "open"
      redirect_to post_path(@post), alert: "開催済み・キャンセル済みの募集は削除できません。"
      return
    end

    @post.destroy
    redirect_to posts_path, notice: "募集を削除しました。", status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_organizer!
    return if @post.organizer?(current_user)

    redirect_to post_path(@post), alert: "この操作を行う権限がありません。"
  end

  def post_params
    params.require(:post).permit(
      :title, :game_name, :event_at, :area, :meeting_place,
      :capacity, :style, :level, :description
    )
  end
end
