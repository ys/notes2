require 'rubygems'
require 'sinatra'
require 'json'
require 'redis'
require 'digest/md5'
class TwoMinutes < Sinatra::Base

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

get '/' do
  redirect '/index.html'
end

post '/new' do
  json = request.body.read
  key = Digest::MD5.hexdigest(json)
  REDIS[key] = json
  REDIS.expire(key, 120)
  content_type :json
  JSON 'url'  => "http://high-fog-986.heroku.com/key/"+key
end

get '/key/:key' do
  content_type :json
  if (REDIS.exists(params[:key]))
    REDIS[params[:key]]
  else
    '{"error":"not found"}';
  end
end
end