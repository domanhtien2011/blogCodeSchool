class Article < ActiveRecord::Base
  is_impressionable
  include PgSearch
  pg_search_scope :search, against: [:title, :body]
  acts_as_taggable
  acts_as_votable
  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 5}
  validates :body, presence: true, length: { minimum: 10}
  has_many :comments, dependent: :destroy
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validate :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
