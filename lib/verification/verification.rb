require_relative '../user/repo'
module Sinatra
  module Verification
    module Helpers
      def check_authentication
        unless warden_handler.authenticated?
          redirect to('/login')
        end
      end

      def warden_handler
        env['warden']
      end

      def current_user
        warden_handler.user
      end
    end
    SuccessMessage = 'Logged in fo shizzle'
    FailureMessage = 'Can\'t let you in bro'
    SessionSecret = ENV['RACK_SESSION_SECRET']
    AccessPaths = ['/login', '/session', '/unauthenticated']
    Repo = User::Repo.new

    def self.registered(app)
      app.use Rack::Session::Cookie, secret: SessionSecret
      app.use Rack::Flash
      app.helpers Helpers

      app.use Warden::Manager do |manager|
        manager.default_strategies :password
        manager.failure_app = TestApp
        manager.serialize_into_session {|user| user.id}
        manager.serialize_from_session {|id| Repo[id]}
      end

      Warden::Strategies.add(:password) do
        def valid?
          params['user'] && params['user']['email'] && params['user']['password']
        end
      
        def authenticate!
          user = Repo.authenticate(params['user']['email'], params['user']['password'])
          user ? success!(user, SuccessMessage) : fail!('no luck jimmey')
        end
      end

      app.before do
        open_paths = AccessPaths+['/unprotected']
        check_authentication unless (open_paths).include? request.path
      end

      app.post '/session' do
        warden_handler.authenticate!
        flash[:success] = warden_handler.message
        redirect '/'
      end

      app.post '/unauthenticated' do
        flash[:error] = FailureMessage
        redirect to('/login')
      end

      app.get '/login' do
        'login'
      end
    end
  end
end