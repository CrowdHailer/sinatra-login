ENV['RACK_ENV'] ||= 'development'

# Autoload gems from the Gemfile
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each {|file| require file }
# require_relative 'config/boot'

# class Owner
#   def initialize
#     @id = 2
#   end

#   attr_reader :id
#   class Repo
#     def self.[](id)
#       Owner.new
#     end

#     def self.authenticate(email, password)
#       Owner.new
#     end
#   end
# end

# module Helpers
#   def check_authentication
#     unless warden_handler.authenticated?
#       redirect to('/login')
#     end
#   end

#   def warden_handler
#     env['warden']
#   end

#   def current_user
#     warden_handler.user
#   end
# end

# module Auth
#   SuccessMessage = 'Logged in fo shizzle'
#   FailureMessage = 'Can\'t let you in bro'

#   def self.registered(app) 
#     app.use Rack::Session::Cookie, secret: 's'
#     app.use Rack::Flash
#     app.helpers Helpers

#     app.use Warden::Manager do |manager|
#       manager.default_strategies :password
#       manager.failure_app = App
#       manager.serialize_into_session {|owner| owner.id}
#       manager.serialize_from_session {|id| ::Owner::Repo[id]}
#     end

#     app.before do
#       check_authentication unless (['/login', '/session', '/unauthenticated'] + settings.open_path).include? request.path
#     end

#     Warden::Manager.before_failure do |env,opts|
#       env['REQUEST_METHOD'] = 'POST'
#     end

#     Warden::Strategies.add(:password) do
#       def valid?
#         params['user'] && params['user']['email'] && params['user']['password']
#       end
    
#       def authenticate!
#         user = ::Owner::Repo.authenticate(params['user']['email'], params['user']['password'])
#         user ? success!(user, SuccessMessage) : fail!('no luck jimmey')
#       end
#     end
#   end
# end

# class App < Sinatra::Base
#   register Auth
#   set :open_path, ['/']

#   before '/:id' do
#   end

#   get '/' do
#     'hello world'
#   end

#   get '/login' do
#     'login'
#   end

#   # get '/:id', :auth => :user do
#   get '/:id' do
#     params['id']
#   end

#   post '/session' do
#     warden_handler.authenticate!
#     flash[:success] = warden_handler.message
#     redirect to('/2')
#   end

#   post '/unauthenticated' do
#     flash[:error] = Auth::FailureMessage
#     redirect to('/login')
#   end


# end