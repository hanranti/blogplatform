class User < ActiveRecord::Base

    has_secure_password

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :ratings, dependent: :destroy
    has_many :likes, dependent: :destroy

    validates :username, uniqueness: true,
                         length: { minimum: 3, maximum: 20 }
    validates :password, length: { minimum: 5 }
    validates :password, format: { with: /([A-Z].*\d)|(\d.*[A-Z].*)/,message: "should contain one number and one capital letter" }

    def to_s
        name
    end

end
