class AddBestAnswerToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :best_answer, foreign_key: { to_table: :answers }, on_delete: :cascade
    add_column :answers, :best_flag, :boolean
  end
end
