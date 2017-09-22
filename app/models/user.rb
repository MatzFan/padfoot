# user class
class User < Sequel::Model
  include BCrypt
  plugin :validation_helpers
  plugin :validation_class_methods # needed for validates_confirmation_of

  def validate
    super
    validates_presence %i[name email]
    validates_unique(:email) # CHECKS DB
    validates_format(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :email)
  end

  def password
    Password.new(password_digest) if password_digest # Password is BCrypt class
  end

  def password=(new_password)
    self.password_digest = Password.create(new_password)
  end

  def password_confirmation=(_arg); end # not required from form submit

  def before_create
    generate_auth_token # for cookies
    super
  end

  def before_save # callbacks must be defined, unlike ActiveRecord
    encrypt_confirmation_code if registered?
    super
  end

  def authenticate(confirmation_code)
    @user = User[id]
    return false unless @user # is the user in the DB?
    if @user.confirmation_code == confirmation_code
      self.confirmation = true
      save
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
    confirmation_code = BCrypt::Engine.hash_secret(password, salt)
    normalize(confirmation_code)
  end

  def normalize(string)
    string.delete('/')
  end

  def registered?
    new?
  end

  def generate_auth_token
    self.authenticity_token = SecureRandom.urlsafe_base64(64) # for cookies
  end

  def save_forget_password_token
    self.password_reset_token = SecureRandom.urlsafe_base64(64)
    self.password_reset_sent_date = Time.now
    save
  end
end
