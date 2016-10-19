require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

get '/' do
  @users = [
    'rika0384',
    'yoshikawa1118',
    'shield_remon',
    'ixmel_rd',
    'tuki_remon',
    'noy72',
    'uchi',
    'Yazaten',
    'yuiop',
    'yebityon'
  ]
  @contests = problems
  @solved = Hash[solved(copy(@users)).sort_by { |k, v| v.length }.reverse]
  puts @solved
  @users = @solved.keys
  erb :problems
end

get '/solved/:id' do
  @users = [
#    'rika0384',
    'yoshikawa1118',
#    'shield_remon',
    'ixmel_rd',
#    'tuki_remon',
#    'noy',
#    'uchi',
#    'Yazaten',
#    'yuiop',
#    'yebityon'
  ]
  @contests = problems
  @solved = solved(@users)
  @users = @users.sort_by{ | user | - @solved[user].length }
  case params[:id].to_i
  when 1 then
    erb :abc
  when 2 then
    erb :arc
  when 3 then 
    erb :agc
  when 4 then
    erb :other
  end
end

def copy(users)
  Marshal.load(Marshal.dump(users))
end

def problems
  ary = []
  uri = URI.parse('http://kenkoooo.com/atcoder/json/problems.json')
  json = Net::HTTP.get(uri)
  results = JSON.parse(json)
  for result in results do
    ary.push({
      contest: result['contest'],
      id: result['id'],
      name: result['name']
    })
  end
  ary
end

def solved(users)
  ary = {}
  # get problems
  users.map{|user|
    uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?user='+user)
    json = Net::HTTP.get(uri)
    ary[user] = Array.new
    results = JSON.parse(json)
    results.map! {|problem| 
      ary[user].push(problem)
    }
  }
  ary
end