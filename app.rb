require 'rubygems'
require 'sinatra'
require 'json'
require 'redis'
require 'digest/md5'
uri = URI.parse(ENV["REDISTOGO_URL"])
@redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

get '/' do
  "hello world"
end

put '/' do
  json = request.body
  key = Digest::MD5.hexdigest(json)
  redis[key] = json.to_json
  redis.expire(key, 120)
  'http://high-fog-986.heroku.com/'+key
end

get '/:key' do
  content_type :json
  @redis[params[:key]].to_json
end