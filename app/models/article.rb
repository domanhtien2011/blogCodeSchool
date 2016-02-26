class Article < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: [:name]
  validates :title, presence: true, length: { minimum: 5}
  validates :body, presence: true, length: { minimum: 10}
  has_many :comments, dependent: :destroy
end
