require_relative 'test_helper'

class UserTest < MiniTest::Test
  BCrypt::Engine.cost = 1
  def setup
    @email, @password = 'a@b.com', 'password'
  end

  attr_reader :email, :password

  def test_can_be_initalized_with_email
    user = User.new email: email
    assert_equal email, user.email
  end

  def test_initialized_password_is_encrypted
    user = User.new password: password
    assert_equal user.password, password
    assert_equal BCrypt::Password, user.password.class
  end

  def test_set_password_is_encrypted
    user = User.new
    user.password = password
    assert_equal user.password, password
    assert_equal BCrypt::Password, user.password.class
  end

  def test_password_left_nil_if_not_supplied
    user = User.new
    assert user.password.nil?
  end

  def test_will_initialize_a_password_from_password_digest
    user = User.new
    password_digest = BCrypt::Password.create(password).to_s
    user.password_digest = password_digest
    assert_equal user.password, password 
  end

  def test_can_be_initialized_with_password_digest
    password_digest = BCrypt::Password.create(password).to_s
    user = User.new password_digest: password_digest
    assert_equal user.password, password
  end

  def test_password_digest_can_be_read_as_a_string
    user = User.new password: password
    assert_equal String, user.password_digest.class
    refute_equal user.password_digest, password
  end

  def test_it_can_reset_a_password
    user = User.new
    user.reset_password
    assert_equal String, user.generated_password.class
    assert_equal user.password, user.generated_password
  end

  def test_password_marked_as_insecure_when_using_generated_version
    user = User.new
    user.reset_password
    refute user.password_secure
  end
end