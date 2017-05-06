class RenameLikeToLiked < ActiveRecord::Migration
  def change
    rename_column :likes, :like, :liked
  end
end
