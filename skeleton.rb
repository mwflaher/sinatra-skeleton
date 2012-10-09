require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/asset_pipeline'

require 'slim'
require 'sass'
require 'sprockets'
require 'sprockets-sass'

require 'rails-assets-jquery'
require 'rails-assets-bootstrap'

class Skeleton < Sinatra::Base

  configure do
    enable :logging
    
    set :slim, pretty: true, layout: :'_layouts/responsive', layout_engine: :slim

    set :assets_prefix, %w(assets)
    set :assets_precompile, %w(_responsive.js _responsive.css *.svg)
    
    register Sinatra::AssetPipeline

    if defined?(RailsAssets)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end
    end
  end
  
  configure :development do
    register Sinatra::Reloader
  end

  configure :production do
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == 'protected' and password == 'protected'
    end
  end

  use Rack::Config do |rack_env|
    rack_env['api.tilt.root'] = File.expand_path('views', File.dirname(__FILE__))
  end

  get '/' do
    slim :index
  end

end