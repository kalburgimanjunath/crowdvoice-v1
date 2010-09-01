class SubscriptionMailer < ActionMailer::Base

  default :from => 'Crowdvoice <subscriptions@crowdvoice.org>'

  layout 'email'

  # Confirmation for subscription when created
  def subscription_confirmation(subscription)
    setup_mail(subscription)
    @subject += 'Subscription confirmation'
    @title = 'WELCOME TO CROWDVOICE'
    mail(:to => subscription.email, :subject => @subject)
  end

  # Digest for today's contents added to the voice
  def daily_digest(subscription)
    setup_mail(subscription)
    @contents = @voice.contents.digest
    @subject += "Digest for #{@voice.title}"
    @title = 'HERE\'S YOUR DAILY DIGEST'
    mail(:to => subscription.email, :subject => @subject)
  end

  # Imap download too big!
  #
  # Deliver this email when imap downloads are too big and can't be
  # added to the crowdvoice system.
  #
  # TODO: Refactor subject, code repetition.
  def imap_download_too_big subject, target_recipient, target_receiver
    @subject = '[Crowdvoice] ' + 'Email is too big!'
    @sent_subject, @target_recipient = subject, target_recipient
    @target_receiver = target_receiver
    mail(:to => target_recipient, :subject => @subject) do |format|
      format.text { render 'imap_download_too_big', :layout => nil }
    end
  end

  private

  def setup_mail(subscription)
    @subscription = subscription
    @voice = @subscription.voice
    @subject = '[Crowdvoice] '
  end

end
