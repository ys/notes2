require 'rubygems'
require 'sinatra'
require 'json'
require 'redis'
require 'digest/md5'
uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

get '/' do
  "hello world"
end

put '/' do
  json = request.body.read
  key = Digest::MD5.hexdigest(json)
  REDIS[key] = json
  REDIS.expire(key, 120)
  'http://high-fog-986.heroku.com/'+key
end

get '/:key' do
  content_type :json
  REDIS[params[:key]]
end