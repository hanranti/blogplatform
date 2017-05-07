class User < ActiveRecord::Base

    has_secure_password

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :ratings, dependent: :destroy
    has_many :likes, dependent: :destroy

    validates :password, length: { minimum: 5 },
                         format: { with: /([A-Z].*\d)|(\d.*[A-Z].*)/,message: "should contain one number and one capital letter" },
                         :on => [:create, :update]
#    validates :username, uniqueness: true,
#                         length: { minimum:3, maximum: 20 }

    def to_s
        username
    end

end
