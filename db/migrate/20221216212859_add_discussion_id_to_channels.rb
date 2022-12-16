class AddDiscussionIdToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :discussion_id, :integer
  end
end
