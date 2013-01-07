require 'sinatra'
require 'compass'
require 'helpers'

class App < Sinatra::Base
  include Helpers
  ROOT = File.expand_path('../..', __FILE__)
  set :root, ROOT

  Compass.configuration do |config|
    config.project_path = settings.root
    config.sass_dir = 'styles'
    config.output_style = :compressed
    set :sass, Compass.sass_engine_options
  end

  get "/stylesheet.css" do
    static

    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/application"
  end


  get '/' do
    haml :index, :locals => {:host => '192.168.168.110'}
  end
end
