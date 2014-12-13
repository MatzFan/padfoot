class User < Sequel::Model

  plugin :validation_helpers
  plugin :validation_class_methods # needed for validates_confirmation_of
  validates_confirmation_of :password # a class method in Sequel...

  def validate
    super
    validates_presence [:name, :email]
    validates_unique(:email) # CHECKS DB
    validates_format /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :email
    validates_min_length 8, :password
  end

  def before_save # callbacks must be defined, unlike ActiveRecord
    self.encrypt_confirmation_code if :registered?
    super
  end

  def authenticate(confirmation_code)
    return false unless @user = User[self.id] # is the user in the DB?
    if @user.confirmation_code == confirmation_code
      self.confirmation = true
      self.save
      true
    else
      false
    end
  end

  # private # good practive to make callbacks private
  def encrypt_confirmation_code
    self.confirmation_code = set_confirmation_code
  end

  def set_confirmation_code
    salt = BCrypt::Engine.generate_salt
    confirmation_code = BCrypt::Engine.hash_secret(self.password, salt)
    normalize_confirmation_code(confirmation_code)
  end

  def normalize_confirmation_code(confirmation_code)
    confirmation_code.gsub('/', '')
  end

  def registered?
    self.new?
  end

end
