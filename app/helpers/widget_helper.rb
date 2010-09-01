module WidgetHelper
  def unique_url_for(content)
    url = url_for(content.voice).to_s
    url += "#"
    url += "#{content.id}"
    url
  end
end
