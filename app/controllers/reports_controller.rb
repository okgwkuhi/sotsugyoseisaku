class ReportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @report = Report.new(
      reported_user_id: params[:reported_user_id],
      post_id: params[:post_id]
    )
    @reported_user = User.find(params[:reported_user_id])
  end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      redirect_to root_path, notice: "通報を受け付けました。ご協力ありがとうございます。"
    else
      @reported_user = User.find_by(id: @report.reported_user_id)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit(:reported_user_id, :post_id, :reason, :detail)
  end
end
