require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/streaming'
require 'sprockets'
require 'rmagick'
require 'rufus-scheduler'
require 'coffee-script'
require 'sass'
require 'json'

require_relative 'lib/events'

SCHEDULER = Rufus::Scheduler.start_new

set :root, Dir.pwd
set :public_folder, File.join(settings.root, 'public')
set :views, File.join(settings.root, 'views')

set :sprockets, Sprockets::Environment.new(settings.root)
set :assets_prefix, '/assets'
set :digest_assets, false

['assets/javascripts', 'assets/stylesheets', 'assets/fonts', 'assets/images']. each do |path|
  settings.sprockets.append_path path
end

set server: 'thin', connections: [], history: {}

get '/' do
  erb :index
end

get '/events', provides: 'text/event-stream' do
  response.headers['X-Accel-Buffering'] = 'no' # Disable buffering for nginx
  stream :keep_open do |out|
    settings.connections << out
    out << latest_events
    out.callback { settings.connections.delete(out) }
  end
end

Dir[File.join(settings.root, 'lib', '**', '*.rb')].each {|file| require file }
Dir[File.join(settings.root, 'jobs', '**', '*.rb')].each {|file| require file }
