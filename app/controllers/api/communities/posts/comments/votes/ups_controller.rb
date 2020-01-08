class Api::Communities::Posts::Comments::Votes::UpsController < ApplicationController
  before_action :set_community
  before_action :set_post
  before_action :set_comment
  before_action -> { authorize(Api::Communities::Posts::Comments::Votes::UpsPolicy, @comment) }

  def create
    vote = Communities::Posts::Comments::CreateUpVote.new(@comment, current_user).call

    # TODO remove two following lines after transition to frontend framework
    @comment.reload
    @comment.vote = vote

    render json: {score: comment.score, up_vote_link: comment.up_vote_link, down_vote_link: comment.down_vote_link}
  end

  def destroy
    Communities::Posts::Comments::DeleteUpVote.new(@comment, current_user).call

    # TODO remove following line after transition to frontend framework
    @comment.reload

    render json: {score: comment.score, up_vote_link: comment.up_vote_link, down_vote_link: comment.down_vote_link}
  end

  private

  def set_community
    @community = CommunitiesQuery.new.with_url(params[:community_id]).take!
  end

  def set_post
    @post = @community.posts.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:comment_id])
  end

  def pundit_user
    Context.new(current_user, @community)
  end
end
