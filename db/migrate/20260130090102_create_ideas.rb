class CreateIdeas < ActiveRecord::Migration[7.2]
  def change
    create_table :ideas do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :user, null: false, foreign_key: true
      t.string :status, default: "submitted" # submitted, planned, in_progress, completed, rejected
      t.integer :votes_count, default: 0
      t.string :category
      t.timestamps
    end

    add_index :ideas, :status
    add_index :ideas, :category
    add_index :ideas, :created_at
  end
end
