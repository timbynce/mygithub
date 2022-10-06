# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'Voted' do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:votable) { create(described_class.to_s.underscore.remove("s_controller").to_sym, author_id: user.id) }

  describe 'PATCH #like' do
    before { login(another_user) }

    it "assign like" do
      expect { patch :like, params: { id: votable.id } }.to change(Vote, :count).by(1)
    end
  end

  describe 'PATCH #dislike' do
    before { login(another_user) }

    it "assign dislike" do
      expect { patch :dislike, params: { id: votable.id } }.to change(Vote, :count).by(1)
    end
  end
end

