xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Content for voice #{@voice.title} on Crowdvoice.org"
    xml.description "Listing of all contents for voice #{@voice.title} on Crowdvoice.org #{@voice.contents.size}"
    xml.link voice_url(@voice, :rss)
    for content in @voice.contents.find(:all, :conditions => {:approved => true})
      xml.item do
        case content.class.name.downcase
          when "link"
            xml.title content.page_title
            xml.description content.page_content
          when "image"
            xml.title content.url
            xml.description content.description
          when "video"
            xml.title content.page_title
            xml.description "No description"
        end
        
        xml.pubDate content.created_at.to_s(:rfc822)
        xml.link "#{voice_url(content.voice)}##{content.id}"
        xml.guid "#{voice_url(content.voice)}##{content.id}"
      end
    end
  end
end
