require 'rails_helper'

RSpec.describe Answer, type: :model do
  # tests of association
  it { should belong_to :question }

  # tests of validation
  it { should validate_presence_of :body }
end
