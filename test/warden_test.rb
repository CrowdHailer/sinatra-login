# require_relative 'test_helper'

# class WardenTest < MiniTest::Test
#   include Rack::Test::Methods
#   include Warden::Test::Helpers

#   def teardown
#     Warden.test_reset!
#   end

#   def app
#     App
#   end

#   def flash
#     last_request.env['x-rack.flash']
#   end

#   def test_home_page_is_open
#     get '/'
#     assert last_response.ok?
#   end

#   def test_content_page_redirects
#     get '/1'
#     follow_redirect!
#   end

#   def test_can_be_authenticated
#     post '/session', 'user' => {'email' => 'a@b', 'password' => 'password'}
#     assert_equal Auth::SuccessMessage, flash[:success]
#     assert last_response.redirect?
#   end

#   def test_error_message_for_unauthenticated
#     Owner::Repo.stub :authenticate, nil do
#       post '/session', 'user' => {'email' => 'a@b', 'password' => 'password'}
#       assert_equal Auth::FailureMessage, flash[:error]
#       follow_redirect!
#     end
#   end

#   def test_logged_in_can_visit_page
#     login_as Owner.new
#     get '/1'
#     assert last_response.ok?
#   end

#   def test_current_user
#     login_as Owner.new
#     get '/1'
#     assert_equal Owner.new.id, last_request.env['warden'].user.id
#   end
# end