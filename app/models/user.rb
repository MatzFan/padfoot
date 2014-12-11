class User < Sequel::Model

  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :email, :password]
    validates_unique(:email) # CHECKS DB
    validates_format /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :email
    validates_min_length 8, :password
  end

end
