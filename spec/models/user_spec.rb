require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_many :answers }
    it { should have_many :questions }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'is_author?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let(:question) { create(:question, author_id: user.id) }
    let(:another_question) { create(:question, author_id: another_user.id) }

    it 'is true when asked for owned' do
      expect(user).to be_is_author(question)
    end

    it 'is true when asked for some one else object' do
      expect(user).not_to be_is_author(another_question)
    end
  end
end
