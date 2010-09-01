class Vote < ActiveRecord::Base

  belongs_to :content

  validates :ip_address,
    :presence => true,
    :already_voted => true

  after_save :update_vote_counters
  after_save :update_content_approval

  def positive?
    rating == 1
  end

  def negative?
    rating == -1
  end

  private

  # updates the counters of the content depending on the vote
  def update_vote_counters
    if positive?
      Content.increment_counter(:positive_votes_count, content.id)
    else
      Content.increment_counter(:negative_votes_count, content.id)
    end

    content.reload.update_attribute(:overall_score, content.positive_votes_count - content.negative_votes_count)
  end

  # Approves content if overall_score is greater than zero
  def update_content_approval
    content.update_attribute(:approved, content.overall_score >= Settings.approved_threshold.to_i)
  end

end
