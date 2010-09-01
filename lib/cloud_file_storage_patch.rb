module CloudFiles
  class StorageObject
    def read
      data
    end
  end
end

module Paperclip
  module Storage
    module Rackspace
      def self.extended base
        require 'cloudfiles'
        @@container ||= {}
        base.instance_eval do
          @cloudfiles_credentials = parse_credentials(@options[:cloudfiles_credentials])
          @container_name         = @options[:container]              || @cloudfiles_credentials[:container]
          @container_name         = @container_name.call(self) if @container_name.is_a?(Proc)
          @cloudfiles_options     = @options[:cloudfiles_options]     || {}
          @@cdn_url               = cloudfiles_container.cdn_url
          @path_filename          = ":cf_path_filename" unless @url.to_s.match(/^:cf.*filename$/)
          @url = @@cdn_url + "/#{URI.encode(@path_filename).gsub(/&/,'%26')}"
          @path = (Paperclip::Attachment.default_options[:path] == @options[:path]) ? ":attachment/:id/:style/:basename.:extension" : @options[:path]
        end
          Paperclip.interpolates(:cf_path_filename) do |attachment, style|
            attachment.path(style)
          end
      end
      
      def cloudfiles
        @@cf ||= CloudFiles::Connection.new(@cloudfiles_credentials[:username], @cloudfiles_credentials[:api_key], true, @cloudfiles_credentials[:servicenet])
      end

      def create_container
        container = cloudfiles.create_container(@container_name)
        container.make_public
        container
      end
      
      def cloudfiles_container
        @@container[@container_name] ||= create_container
      end

      def container_name
        @container_name
      end

      def parse_credentials creds
        creds = find_credentials(creds).stringify_keys
        (creds[RAILS_ENV] || creds).symbolize_keys
      end
      
      def exists?(style = default_style)
        cloudfiles_container.object_exists?(path(style))
      end

      # Returns representation of the data of the file assigned to the given
      # style, in the format most representative of the current storage.
      def to_file style = default_style
        @queued_for_write[style] || cloudfiles_container.create_object(path(style))
      end
      alias_method :to_io, :to_file

      def flush_writes #:nodoc:
        @queued_for_write.each do |style, file|
            object = cloudfiles_container.create_object(path(style),false)
            object.write(file)
        end
        @queued_for_write = {}
      end

      def flush_deletes #:nodoc:
        @queued_for_delete.each do |path|
          cloudfiles_container.delete_object(path)
        end
        @queued_for_delete = []
      end
      
      def find_credentials creds
        case creds
        when File
          YAML.load_file(creds.path)
        when String
          YAML.load_file(creds)
        when Hash
          creds
        else
          raise ArgumentError, "Credentials are not a path, file, or hash."
        end
      end
      private :find_credentials

    end
    
  end
end