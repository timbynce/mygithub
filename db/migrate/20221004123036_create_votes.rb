class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true, null: false
      t.bigint :like_value, null:false
      t.timestamps
    end
  end
end
