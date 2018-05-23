module Ratinged
  extend ActiveSupport::Concern

  included do
    before_action :find_rating_resource, only: [:vote_up, :vote_down, :vote_reset]
    before_action :vote_access, only: [:vote_up, :vote_down]
  end

  def vote_up
    @rating_resource.vote_up(current_user)
    render_json_details
  end

  def vote_down
    @rating_resource.vote_down(current_user)
    render_json_details
  end

  def vote_reset
    if @rating_resource.voted_by?(current_user)
      @rating_resource.vote_reset(current_user)
      render_json_details
    else
      head :unprocessable_entity
    end
  end

  private

  def vote_access
    if @rating_resource.voted_by?(current_user) || current_user.author_of?(@rating_resource)
      head :unprocessable_entity
    end
  end

  def find_rating_resource
    @rating_resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_json_details
    render json: { rating: @rating_resource.rating, klass: @rating_resource.class.to_s, id: @rating_resource.id }
  end
end
