class User < ActiveRecord::Base
  has_secure_password

  has_many :devices

  before_save { |user| user.username = username.downcase }
  before_save :create_remember_token
  before_save :make_admin

  validates :name, presence: true, length: { maximum: 50 }
  validates :username, presence:   true,
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def make_admin
      if User.all.count == 0
        self.admin=true
      end
    end


end