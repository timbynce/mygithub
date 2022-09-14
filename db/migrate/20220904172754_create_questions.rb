class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body
      t.references :author, null: false, foreign_key: { to_table: :users }
      
      t.timestamps
    end
  end
end
