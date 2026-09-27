class WantAgainResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :ensure_eligible!

  def new
    @participants = eligible_targets
  end

  def create
    target_user_id = params[:target_user_id]
    wants_again = params[:wants_again] == "true"

    response = @post.want_again_responses.find_or_initialize_by(
      user_id: current_user.id,
      target_user_id: target_user_id
    )
    response.wants_again = wants_again

    if response.save
      redirect_to new_post_want_again_response_path(@post), notice: "回答しました。"
    else
      redirect_to new_post_want_again_response_path(@post), alert: response.errors.full_messages.join(", ")
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def ensure_eligible!
    return if @post.organizer_id_or_approved_applicant?(current_user.id)

    redirect_to post_path(@post), alert: "この操作を行う権限がありません。"
  end

  def eligible_targets
    ids = @post.approved_user_ids + [@post.user_id]
    User.where(id: ids).where.not(id: current_user.id)
  end
end
