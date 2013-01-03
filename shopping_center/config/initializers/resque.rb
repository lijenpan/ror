require 'resque/server'
require 'resque-retry'
require 'resque-retry/server'
require 'yaml'

redis_config = YAML::load(File.open(File.join("#{Rails.root}/config/redis.yml")))[Rails.env]
Resque.redis = Redis.new(:host => redis_config['host'], :port => redis_config['port'], :user => redis_config['user'], :password => redis_config['password'])

Resque::Server.use Rack::Auth::Basic do |user,password|
  user == ""
  password == ""
end

Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }
