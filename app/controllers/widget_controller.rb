class WidgetController < ApplicationController
  before_filter :get_size_params, :only => [:show]

  def show
    @voice = Voice.find_by_slug!(params[:id])

    filter_contents = @voice.contents.approved
    @contents = filter_contents
  end

  private
  def get_size_params
    
    @list_height_size = case params["size"]
                        when "small"
                          "small-list"
                        when "medium"
                          "medium-list"
                        when "tall"
                          "tall-list"
                        end

    width_size = get_width(params["width"])

    case width_size
    when "small"
      @content_image_size = "40x40"
      @voice_image_size = "50x50"
      @list_width_size = "small-size"
    when "default"
      @content_image_size = "54x51"
      @voice_image_size = "61x67"
      @list_width_size = "default-size"
    end


    if params["show_description"] && params["show_description"] == "true"
      @show_description = true
    else
      @show_description = false
    end

  end

  def get_width(width)
    size = "default"
    unless width.nil?
      if width == "small" || width.to_i <= 200
        size = "small"
      end
    end

    size
  end

end
