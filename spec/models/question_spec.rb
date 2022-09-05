require 'rails_helper'

RSpec.describe Question, type: :model do


# validates tests
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
