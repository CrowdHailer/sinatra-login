require_relative 'test_helper'

class TestApp < Sinatra::Base
  register Sinatra::Verification

  get '/protected' do
    'producted'
  end

  get '/unprotected' do
    'unprotected'
  end

  get '/' do
    'home'
  end
end

class VerificationTest < MiniTest::Test
  include Rack::Test::Methods
  include Warden::Test::Helpers

  def teardown
    Warden.test_reset!
  end

  def app
    TestApp
  end

  def flash
    last_request.env['x-rack.flash']
  end

  def test_redirect_from_protected_pages
    get '/protected'
    assert last_response.redirect?
  end

  def test_view_unprotected_page
    get '/unprotected'
    refute last_response.redirect?
    assert last_response.ok?
  end

  def test_redirect_on_authentication_failure
    Sinatra::Verification::Repo.stub :authenticate, nil do
      post '/session', 'user' => {'email' => 'a@b', 'password' => 'password'}
      assert_equal Sinatra::Verification::FailureMessage, flash[:error]
      assert last_response.redirect?
    end
  end

  def test_redirect_on_authentication_sucess
    Sinatra::Verification::Repo.stub :authenticate, User.new({id: 1}) do
      post '/session', 'user' => {'email' => 'a@b', 'password' => 'password'}
      Sinatra::Verification::Repo.stub :[], User.new({id: 1}) do
        follow_redirect!
      end
    end
    assert last_response.ok?
    assert_equal Sinatra::Verification::SuccessMessage, flash[:success]
    assert last_request.env['warden'].user
  end

  def test_logged_in_user_can_visit_protected_pages
    login_as User.new({id: 1})
    get '/protected'
    refute last_response.redirect?
  end
end