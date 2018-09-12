class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
	  t.belongs_to :group
	  t.string :title
	  t.string :details
	  t.string :link
      t.timestamps
    end
  end
end
