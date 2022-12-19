# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: 'is not a valid URL'
  }

  def is_a_gist?
    url.start_with?('https://gist.github.com')
  end
end
