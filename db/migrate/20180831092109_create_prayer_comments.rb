class CreatePrayerComments < ActiveRecord::Migration[5.2]
  def change
    create_table :prayer_comments do |t|
      t.belongs_to :prayer
      t.belongs_to :user
      t.text :comment
      t.timestamps
    end
  end
end
