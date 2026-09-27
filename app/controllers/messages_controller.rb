class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match
  before_action :ensure_participant!

  def create
    @message = @match.messages.new(message_params)
    @message.sender = current_user

    if @message.save
      redirect_to match_path(@match)
    else
      @messages = @match.messages.includes(:sender).order(:created_at)
      render "matches/show", status: :unprocessable_entity
    end
  end

  private

  def set_match
    @match = Match.find(params[:match_id])
  end

  def ensure_participant!
    return if [@match.user_a_id, @match.user_b_id].include?(current_user.id)

    redirect_to matches_path, alert: "この操作を行う権限がありません。"
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
