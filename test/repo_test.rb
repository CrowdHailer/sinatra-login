require_relative 'test_helper'

class RepoTest < MiniTest::Test
  def setup
    @empty_repo = User::Repo.new
    @valid_user = User.new email: 'a@b.com', password: 'password'
    @repo = User::Repo.new
    @repo.create @valid_user
  end

  attr_reader :empty_repo, :repo, :valid_user

  def test_starts_empty
    assert empty_repo.empty?
  end

  def test_can_create_an_entry
    user = User.new
    empty_repo.create user
    assert_equal 0, user.id
  end

  def test_can_get_user_by_id
    assert_equal valid_user, repo[0]
  end

  def test_can_get_user_by_email
    assert_equal valid_user, repo.find_by_email('a@b.com')
  end

  def test_can_authenticate_user
    assert_equal valid_user, repo.authenticate('a@b.com', 'password')    
  end

  def test_returns_nil_for_incorrect_password
    assert_equal nil, repo.authenticate('a@b.com', 'failure')
  end
end