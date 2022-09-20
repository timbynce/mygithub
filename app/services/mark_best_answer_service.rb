class MarkBestAnswerService
  def initialize(question, answer)
    @question = question
    @answer = answer
  end

  def call
    mark_new_as_best
  end

  private

  def mark_new_as_best
    @question.best_answer.best_flag = false if @question.best_answer.present?
    @question.best_answer_id = @answer.id
    @question.best_answer.best_flag = true

    @question.save
  end

end
