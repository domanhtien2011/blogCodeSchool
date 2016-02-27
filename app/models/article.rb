class Article < ActiveRecord::Base
  is_impressionable
  include PgSearch
  pg_search_scope :search, against: [:title, :body]
  acts_as_taggable
  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 5}
  validates :body, presence: true, length: { minimum: 10}
  has_many :comments, dependent: :destroy
  belongs_to :user
end
