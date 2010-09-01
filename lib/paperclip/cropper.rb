module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command?
        # super returns an array like ["-resize", "100x", "-crop", "100x100+0+0", "+repage"]
        crop_command + super.join(" ").sub(/ -crop \S+/, "").split(" ")
      else
        super
      end
    end

    def crop_command?
      @attachment.instance.cropping?
    end
    
    def crop_commmand
      target = @attachment.instance
      if target.cropping?
        ["-crop", "#{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}"]
      end
    end
  end
end
