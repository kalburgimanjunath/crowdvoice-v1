desc "Fix width and height for bad thumbnail urls"
task :fix_thumbnails => :environment do
  Link.find_all_by_height(nil).each do |link|
    link.send :fetch_thumbnail
    link.reload
    link.send :save_image_dimensions
  end
end

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
