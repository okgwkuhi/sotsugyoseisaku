class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :ensure_organizer!, only: %i[index update]

  def index
    @applications = @post.applications.includes(:user)
  end

  def new
    @application = @post.applications.new
  end

  def create
    @application = @post.applications.new(application_params)
    @application.user = current_user

    if @application.save
      redirect_to post_path(@post), notice: "応募しました。"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @application = @post.applications.find(params[:id])

    case params[:status]
    when "approved"
      @application.approve!
      redirect_to post_applications_path(@post), notice: "ステータスを更新しました。"
    when "rejected"
      @application.reject!
      redirect_to post_applications_path(@post), notice: "ステータスを更新しました。"
    else
      redirect_to post_applications_path(@post), alert: "不正なステータスです。"
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to post_applications_path(@post), alert: "更新に失敗しました。"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def ensure_organizer!
    return if @post.organizer?(current_user)

    redirect_to post_path(@post), alert: "この操作を行う権限がありません。"
  end

  def application_params
    params.require(:application).permit(:comment)
  end
end
