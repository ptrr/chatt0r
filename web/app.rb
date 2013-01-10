require 'sinatra'
require 'compass'
require 'helpers'
require 'omniauth'
require 'omniauth-github'
require 'zurb-foundation'

class App < Sinatra::Base
  include Helpers
  enable :sessions

  use Rack::Session::Cookie
  auth = false

  use OmniAuth::Builder do
    provider :github, "42e9d13942ad6f74b5b1", "cc8ad46940b79bf239511b8eeade99f638296037"
  end

  #config stuff

  ROOT = File.expand_path('../..', __FILE__)
  set :root, ROOT
  set :sass, { :load_paths => [ "#{settings.root}/views/stylesheets" ] }
  set :sass, Compass.sass_engine_options
  set :scss, sass
  relative_assets = true
  Compass.add_project_configuration(File.join(settings.root, 'compass.config'))

  get '/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass(:"stylesheets/#{params[:name]}" )
  end


  get '/' do
    if auth
      haml :index, :locals => {:host => '192.168.168.110'}
    else
      redirect '/auth/github'
    end
  end

  %w(get post).each do |method|
    send(method, "/auth/:provider/callback") do
      auth = request.env['omniauth.auth']
      if auth 
        redirect '/'
      end
    end
  end

  get '/auth/failure' do
    redirect '/fail'
  end
end
