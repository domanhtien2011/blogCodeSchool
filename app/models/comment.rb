class Comment < ActiveRecord::Base
  validates :name, presence: true
  validates :body, presence: true, length: { minimum: 10}
  belongs_to :article
end
