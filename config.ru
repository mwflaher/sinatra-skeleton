require File.expand_path('../skeleton.rb', __FILE__)

run Rack::URLMap.new('/' => Skeleton.new)