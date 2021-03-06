class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :vkontakte, :twitter]

  has_many :questions
  has_many :answers
  has_many :authorizations, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :comments

  scope :subscribed, -> { where(digest: true) }

  def self.find_for_oauth(auth, options = {})
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = options[:email] || auth.info[:email]
    if email
      user = User.where(email: email).first
      unless user
      password = Devise.friendly_token[0, 20]
      user = User.create(email: email, password: password, password_confirmation: password)
      end
      user.create_authorization(auth)
    end

    user
  end

  def self.send_daily_digest
    if Question.created_today.present?
      subscribed.each do |user|
        DailyMailer.delay.digest(user)
      end
    end
  end

  def create_authorization(auth)
    authorizations.create(uid: auth.uid, provider: auth.provider, avatar_url: auth.info[:image])
  end
end
