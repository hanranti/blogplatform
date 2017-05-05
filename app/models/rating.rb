class Rating < ActiveRecord::Base
    belongs_to :user
    belongs_to :post

    validates :score, numericality: { greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 100,
                                    only_integer: true }
    validates :user_id, uniqueness: true, :on => :create

end
