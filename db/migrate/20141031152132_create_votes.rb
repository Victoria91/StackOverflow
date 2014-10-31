class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.references :question, index: true
      t.integer :vote_type

      t.timestamps
    end
  end
end
