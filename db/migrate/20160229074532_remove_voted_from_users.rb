class RemoveVotedFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :voted, :boolean
  end
end
