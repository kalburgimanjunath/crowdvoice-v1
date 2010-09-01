desc "Update thumbnails' url from own servers"
task :update_thumbnails => :environment do
  Image.all.each do |i|
    i.send :fetch_thumbnail
    i.save
  end
  
  Video.all.each do |v|
    v.send :fetch_thumbnail
    v.save
  end
end

namespace :voices do
  desc "Erase all unapproved contents that has 7 days old"
  task :cleanup => :environment do
    Content.unapproved.where("created_at <= ?", 7.days.ago.utc.beginning_of_day)
  end
end
