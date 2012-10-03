require 'sinatra'
require_relative 'lamp'

def all_lamps
  $lamps ||= [
    Lamp.new(:desk, 3.00),
    Lamp.new(:table, 8.00),
    Lamp.new(:floor, 15.00),
    Lamp.new(:magic, 1000000.00),
    Lamp.new(:mario, 999.00)
  ]
end

get '/' do
  @lamps = all_lamps
  erb(:index, :layout => :common_layout)
end


get '/lamps/:id' do
  id = params[:id].to_i
  raise "Not valid ID" if id >= all_lamps.size

  @lamp = all_lamps[id]
  erb :lamp, :layout => :common_layout
end

get '/buy/:id' do
  id = params[:id].to_i
  raise "Not valid ID" if id >= all_lamps.size

  @lamp = all_lamps[id]
  erb :buy, :layout => :common_layout
end
