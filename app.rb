require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
get '/' do
    return 'this is' 
end

get '/count' do
  "Hello World"
end

get '/ruby' do
  uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?user=kenkoooo&rivals=Yazaten,ixmel,Rp7rf')
  json = Net::HTTP.get(uri)
  result = JSON.parse(json)
  return result.to_json
    return 'a'  
end