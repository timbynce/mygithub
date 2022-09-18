class AddBestAnswerToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :best_answer, foreign_key: { to_table: :users }
  end
end
