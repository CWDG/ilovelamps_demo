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
  @lamp = find_lamp_by_id(params)
  erb :lamp, :layout => :common_layout
end

get '/buy/:id' do
  @lamp = find_lamp_by_id(params)
  erb :buy, :layout => :common_layout
end

post '/buy/:id' do
  @lamp = find_lamp_by_id(params)
  q = params[:quantity].to_i
  if q <= 0
    # can't order 0
    @error = "You must order at least one lamp!"
    erb :buy, :layout => :common_layout
  elsif q > @lamp.quantity
    # cant order that many
    @error = "Sorry, we don't have that many in stock. Order fewer lamps."
    erb :buy, :layout => :common_layout
  else
    # yay
    @lamp.quantity -= q
    erb :thankyou, :layout => :common_layout
  end
end

def find_lamp_by_id(params)
  id = params[:id].to_i
  raise "Not valid ID" if id >= all_lamps.size

  all_lamps[id]
end
