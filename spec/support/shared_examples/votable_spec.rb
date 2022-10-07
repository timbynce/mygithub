# frozen_string_literal: true

require 'rails_helper'
RSpec.shared_examples 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:votable) { create(described_class.to_s.underscore.to_sym, author_id: user.id) }

    context 'when does not have any votes' do
      it 'is null' do
        expect(votable.rating).to be_zero
      end
    end

    context 'when has votes' do
      let!(:like_votes) { create_list :vote, 2, :like, votable: votable }
      let!(:dislike_votes) { create_list :vote, 1, :dislike, votable: votable }

      it 'is returning sum of likes and dislikes' do
        expect(votable.rating).to eq 1
      end
    end
  end
end
