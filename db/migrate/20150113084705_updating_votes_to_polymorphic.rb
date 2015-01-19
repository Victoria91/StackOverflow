class UpdatingVotesToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :votes, :question_id, :voteable_id
    add_column :votes, :voteable_type, :string, default: 'Question'
  end

  def down
    rename_column :votes, :voteable_id, :question_id
    remove_column :votes, :voteable_type
  end
end
