# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'Commented' do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:votable) { create(described_class.to_s.underscore.remove('s_controller').to_sym, author_id: user.id) }

  describe 'POST #comment' do
    before { login(another_user) }

    it 'assign comment' do
      expect { post :like, params: { id: votable.id } }.to change(Comment, :count).by(1)
    end
  end
end
