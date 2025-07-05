namespace :chatwoot do
  desc 'Clear GlobalConfig cache'
  task clear_cache: :environment do
    puts 'Clearing GlobalConfig cache...'
    GlobalConfig.clear_cache
    puts 'GlobalConfig cache cleared successfully!'
  end
end