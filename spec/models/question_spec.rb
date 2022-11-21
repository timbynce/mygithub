# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to :author }
    it { should belong_to(:best_answer).class_name('Answer').optional }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  it { should accept_nested_attributes_for :links }

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { build(:question, author_id: user.id) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
