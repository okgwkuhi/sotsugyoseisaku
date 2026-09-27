class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: [:show]
  before_action :ensure_participant!, only: [:show]

  def index
    @matches = Match.for_user(current_user.id).includes(:post, :user_a, :user_b)
  end

  def show
    @messages = @match.messages.includes(:sender).order(:created_at)
    @message = Message.new
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def ensure_participant!
    return if [@match.user_a_id, @match.user_b_id].include?(current_user.id)

    redirect_to matches_path, alert: "この操作を行う権限がありません。"
  end
end
