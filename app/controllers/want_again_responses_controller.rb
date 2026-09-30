class WantAgainResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :ensure_eligible!

  def new
    @participants = eligible_targets
    @my_responses = @post.want_again_responses
                         .where(user_id: current_user.id)
                         .index_by(&:target_user_id)
  end

  def create
    result = WantAgainResponseRecorder.call(
      post: @post,
      current_user: current_user,
      target_user_id: params[:target_user_id],
      wants_again: params[:wants_again] == "true"
    )

    if result.success?
      message = result.match ? "回答しました。マッチしました!" : "回答しました。"
      redirect_to new_post_want_again_response_path(@post), notice: message
    else
      redirect_to new_post_want_again_response_path(@post), alert: result.response.errors.full_messages.join(", ")
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
