
namespace :imod do

  desc 'download remote imap server'
  task :download => :environment do
    require 'lib/imod/imod'
    require 'lib/imod/plugins/imod_log_plugin'
    require 'lib/imod/plugins/imod_atachment_downloader_plugin'

    yaml    = YAML::load_file('config/imod_config.yml')
    config  = ImodConfig.new(yaml)
    imod    = Imod.new(config, Rails.root)

    imod.add_plugin(ImodLogPlugin)
    imod.add_plugin(ImodAttachmentDownloaderPlugin)
    imod.run_plugins

    puts 'Done!'
  end

end

