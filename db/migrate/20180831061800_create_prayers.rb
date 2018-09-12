class CreatePrayers < ActiveRecord::Migration[5.2]
  def change
    create_table :prayers do |t|
	  t.belongs_to :user
	  t.string :subject
	  t.string :details
	  t.string :answered_details
	  t.integer :is_answered
      t.timestamps
    end
  end
end
