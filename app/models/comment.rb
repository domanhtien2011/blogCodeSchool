class Comment < ActiveRecord::Base
  validates :name, presence: true
  validates :body, presence: true, length: { minimum: 10}
  acts_as_votable
  belongs_to :article
end
