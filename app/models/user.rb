class User < ActiveRecord::Base

  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :password, length: { minimum: 5 },
                         format: { with: /([A-Z].*\d)|(\d.*[A-Z].*)/,message: "should contain one number and one capital letter" },
                         :on => [:create, :update]
#  Seuraava ei hyvaksy mitaan usernamea
#  validates :username, uniqueness: true,
#                         length: { minimum:3, maximum: 20 }
  validate do |user|
    user.errors[:username] << 'cannot be blank!' if user.username.nil?
    user.errors[:this_username] << 'is already in use!' if User.find_by(username: user.username)
    user.errors[:username_length] << 'has to be at least 3 letters!' if user.username && user.username.length < 3
    user.errors[:username_length] << 'cannot be more than 20 letters!' if user.username && user.username.length > 20
  end

  def to_s
    username
  end

end
