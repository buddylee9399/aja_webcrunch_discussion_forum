class AddChannelIdToDiscussions < ActiveRecord::Migration[7.0]
  def change
    add_column :discussions, :channel_id, :integer
  end
end
