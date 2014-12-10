class User < Sequel::Model

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    errors.add(:email, 'cannot be empty') if !email || email.empty?
    errors.add(:password, 'cannot be empty') if !password || password.empty?
  end

end
