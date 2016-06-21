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
    'yuiop'
  ]
  @contests = problems
  @solved = Hash[solved(copy(@users)).sort_by { |k, v| v.length }.reverse]
  puts @solved
  @users = @solved.keys
  erb :problems
end

get '/solved' do
  @users = [
    'rika0384',
    'yoshikawa1118',
    'shield_remon',
    'ixmel_rd',
    'tuki_remon',
    'noy',
    'uchi',
    'Yazaten',
    'yuiop'
  ]
  @solved = solved(copy(@users))
  return (@solved["uchi"].include?("abc013_2") ? "YES": "NO")
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
  user_str = ""
  users.map! {|user| 
    user_str += user + ',' 
    ary[user] = []
  }
  # get problems
  uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?rivals=' + user_str)
  json = Net::HTTP.get(uri)
  results = JSON.parse(json)
  results.map! {|problem| 
    problem["rivals"].map! { |rival|
      ary[rival].push(problem["id"])
    }
  }
  ary
end