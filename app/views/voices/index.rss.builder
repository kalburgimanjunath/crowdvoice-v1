xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Top Videos on Crowdvoice.org"
    xml.description "Listing of all the top videos on Crowdvoice.org"
    xml.link voices_url(:rss)
    
    for voice in @voices
      xml.item do
        xml.title voice.title
        xml.description voice.about
        xml.pubDate voice.created_at.to_s(:rfc822)
        xml.link voice_url(voice)
        xml.guid voice_url(voice)
      end
    end
  end
end