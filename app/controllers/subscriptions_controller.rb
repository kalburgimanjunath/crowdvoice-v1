class SubscriptionsController < ApplicationController
  before_filter :find_voice
  
  def create
    @subscription = @voice.subscriptions.build(params[:subscription])
    if @subscription.save
      Delayed::Job.enqueue DelayedMailer::ConfirmationJob.new(@subscription.id)
      flash[:notice] = "You have subscribed to this voice. Check your inbox!"
    else
      flash[:alert] = @subscription.errors.full_messages.to_sentence
    end
    redirect_to @voice
  end
  
  def destroy
    @subscription = Subscription.find_by_email_hash(params[:id])
    @subscription.destroy
    flash[:notice] = "You have unsubscribed from this voice."
    redirect_to @voice
  end
  
  private
  
  def find_voice
    @voice = Voice.find_by_slug(params[:voice_id])
  end
end
