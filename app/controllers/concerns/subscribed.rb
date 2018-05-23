module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :find_subscription_resource, only: [:subscribe, :unsubscribe]
  end

  def subscribe
    @subscription_resource.subscribe(current_user)
    redirect_to @subscription_resource, notice: 'You have successfully subscribed'
  end

  def unsubscribe
    @subscription_resource.unsubscribe(current_user)
    redirect_to @subscription_resource, notice: 'You successfully unsubscribed'
  end

  private

  def find_subscription_resource
    @subscription_resource = controller_name.classify.constantize.find(params[:id])
  end
end
