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

  def before_create
    save_auth_token
    super
  end

  def before_save # callbacks must be defined, unlike ActiveRecord
    encrypt_confirmation_code if :registered?
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


  private # good practive to make callbacks private
  def encrypt_confirmation_code
    self.confirmation_code = set_confirmation_code
  end

  def set_confirmation_code
    salt = BCrypt::Engine.generate_salt
    confirmation_code = BCrypt::Engine.hash_secret(self.password, salt)
    normalize(confirmation_code)
  end

  def normalize(string)
    string.gsub('/', '')
  end

  def registered?
    self.new?
  end

  def save_auth_token
    self.authenticity_token = normalize(SecureRandom.base64(64))
  end

  def save_forget_password_token
    self.password_reset_token = generate_auth_token
    self.password_reset_sent_date = Time.now
    self.save
  end

end
