class WantAgainResponseRecorder
  Result = Struct.new(:response, :match, :success?)

  def self.call(...)
    new(...).call
  end

  def initialize(post:, current_user:, target_user_id:, wants_again:)
    @post = post
    @current_user = current_user
    @target_user_id = target_user_id
    @wants_again = wants_again
  end

  def call
    response = @post.want_again_responses.find_or_initialize_by(
      user_id: @current_user.id,
      target_user_id: @target_user_id
    )
    response.wants_again = @wants_again

    unless response.save
      return Result.new(response, nil, false)
    end

    match = Match.find_or_create_from_mutual!(
      post: @post,
      user1_id: @current_user.id,
      user2_id: @target_user_id.to_i
    )

    Result.new(response, match, true)
  end
end

