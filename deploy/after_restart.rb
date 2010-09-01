
# ==============================================================================
# SETUP
# ==============================================================================

home        = "cd #{release_path} && HOME=/home/deploy &&"
env         = "RAILS_ENV=#{node['environment']['framework_env']}"
delay_pid   = 'tmp/pids/delayed_job.pid'
pid_dir     = '/data/crowdvoice/shared/pids'

# ==============================================================================
# INSTALLING CRON JOBS.
# ==============================================================================
puts 'Installing cron jobs.'
run "#{home} cd cron && whenever --load-file schedule.rb -w"

# ==============================================================================
# CREATE PIDS DIR ONLY IF IT DOES NOT EXIST
# ==============================================================================
run "#{home} mkdir #{pid_dir}" unless ::File.directory? pid_dir

# ==============================================================================
# STOP DELAYED JOBS, ONLY IF PID FILE IS FOUND
# ==============================================================================
if ::File.exist? "#{release_path}/#{delay_pid}"
  run "#{home} #{env} ./script/delayed_job stop"
end

# ==============================================================================
# START DELAYED JOBS
#
# Note:
#
#  - *pid_dir* needs to exist.
# ==============================================================================
run "#{home} #{env} RAILS_ENV=production nohup script/delayed_job run &"
