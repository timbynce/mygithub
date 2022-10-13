# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }
  let(:answer) { create(:answer, author_id: user.id, question: question) }

  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to :author }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
