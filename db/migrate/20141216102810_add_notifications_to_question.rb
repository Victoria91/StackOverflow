class AddNotificationsToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :notifications, :boolean, default: true
  end
end
