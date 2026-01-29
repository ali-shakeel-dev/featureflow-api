class CreateRoadmapItems < ActiveRecord::Migration[7.2]
  def change
    create_table :roadmap_items do |t|
      t.string :title, null: false
      t.text :description
      t.string :status, default: "planned" # planned, in_progress, completed
      t.date :target_date
      t.references :idea, foreign_key: true
      t.integer :priority, default: 0
      t.timestamps
    end

    add_index :roadmap_items, :status
    add_index :roadmap_items, :target_date
  end
end
