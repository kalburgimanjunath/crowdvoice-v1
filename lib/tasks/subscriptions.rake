namespace :subscriptions do
  desc "Delivers a digest with all today's contents to the subscriptions"
  task :digest => :environment do
    # OPTIMIZE: send only one mail per voice to all users subscribed as bcc
    Subscription.all.each do |subscription|
      Delayed::Job.enqueue DelayedMailer::DigestJob.new(subscription.id)
    end
  end
end
