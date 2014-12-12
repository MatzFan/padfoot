class User < Sequel::Model

  plugin :validation_helpers
  plugin :validation_class_methods # needed for validates_confirmation_of
  validates_confirmation_of :password # a class method in Sequel...

  def validate
    super
    validates_presence [:name, :email, :confirmation_code]
    validates_unique(:email) # CHECKS DB
    validates_format /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :email
    validates_min_length 8, :password
  end

end
