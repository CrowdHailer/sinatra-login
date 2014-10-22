class User
  PasswordCharachters = [*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)
  attr_accessor :id, :email, :password_digest, :generated_password

  def initialize(attributes = {})
    self.id = attributes[:id] if attributes[:id]
    self.email = attributes[:email] if attributes[:email]
    self.password = attributes[:password] if attributes[:password]
    self.password_digest = attributes[:password_digest] if attributes[:password_digest]
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def password
    BCrypt::Password.new password_digest if password_digest
  end

  def reset_password
    generated_password = PasswordCharachters.sample(8).join
    self.password = generated_password
    self.generated_password = generated_password
  end

  def password_secure
    !(password == generated_password)
  end
end