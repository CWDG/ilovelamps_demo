require 'sinatra'
require_relative 'lamp'

if Lamp.count.zero?
  Lamp.create(:desk, 14.00, 250)
  Lamp.create(:table, 24.99, 85)
  Lamp.create(:floor, 45.00, 46)
  Lamp.create(:magic, 1000000.00, 1)
  Lamp.create(:mario, 99.00, 4)
end

get '/' do
  @lamps = Lamp.all
  erb(:index, :layout => :common_layout)
end


get '/lamps/:id' do
  @lamp = Lamp.find(params[:id].to_i)
  erb :lamp, :layout => :common_layout
end

get '/buy/:id' do
  @lamp = Lamp.find(params[:id].to_i)
  erb :buy, :layout => :common_layout
end

post '/buy/:id' do
  @lamp = Lamp.find(params[:id].to_i)
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
    @lamp.save
    erb :thankyou, :layout => :common_layout
  end
end
