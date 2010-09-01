class String

  def looks_like_voice_mail?
    (self.is_a? String) && (self =~ /\+/)
  end

  def extract_voice_id
    return '' unless looks_like_voice_mail?
    self.split('+').second
  end

end
