module VoicesHelper
  # Sets the meta tags for facebook sharer
  def facebook_sharer_meta_tags(voice)
    content_for(:head) do
      meta = <<-eos
        <meta name="title" content="#{voice.title}" />
        <meta name="description" content="#{voice.about} " />
        <link rel="image_src" href="#{voice.background_image(:small)}" />
      eos
      meta.html_safe
    end
  end

  # Adds keywords meta tag
  def keywords_meta_tag(voice)
    return "" if voice.keywords.blank?
    content_for(:head) do
      meta = <<-eos
        <meta name="keywords" content="#{voice.keywords.gsub(/,?\r\n/, ',').gsub(/, +/, ',')}" />
      eos
      meta.html_safe
    end
  end
  
  # Generates check_box for filter for the passed type
  def check_box_for_filter(filter_value)
    checked = (params[:filter] || []).include?(filter_value)
    check_box_tag "filter[]", filter_value, checked, :class => "filter_voice_cb"
  end
  
  # Generates radio button for the passed limit value
  def radio_button_for_limit(value)
    limit = (params[:limit] || [0])
    selected = limit.include?(value)
    radio_button_tag :limit, value, selected, :class => 'limit_voice_rb'
  end
end
