# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkBestAnswerService, type: :model do
  describe 'call' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author_id: user.id) }
    let!(:another_question) { create(:question, author_id: user.id) }
    let!(:answer) { create(:answer, author_id: user.id, question: question) }
    let!(:another_answer) { create(:answer, author_id: user.id, question: another_question) }

    it 'can mark best answer for question' do
      MarkBestAnswerService.call(answer)

      expect(answer.question.best_answer).to eq(answer)
    end

    it 'can not mark answer from another question for question' do
      MarkBestAnswerService.call(another_answer)

      expect(answer.question.best_answer).to_not eq(another_answer)
      expect(answer.question.errors.messages).to match(base: ['Foreign answer detected'])
    end
  end
end
