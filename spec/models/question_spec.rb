# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  # tests of association
  it { should have_many :answers }

  # tests of validation
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
