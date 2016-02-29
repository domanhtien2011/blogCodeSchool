class AddVotedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :voted, :boolean
  end
end
