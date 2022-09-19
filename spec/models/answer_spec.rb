# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }
  let(:answer) { create(:answer, author_id: user.id, question: question) }

  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to :author }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'mark_as_best' do
    before { answer.mark_as_best }
    it { expect(question.best_answer).to eq answer }
  end
end
