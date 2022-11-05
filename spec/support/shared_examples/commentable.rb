# frozen_string_literal: true

require 'rails_helper'
RSpec.shared_examples 'commentable' do
  it { is_expected.to have_many(:comments).dependent(:destroy) }
end
