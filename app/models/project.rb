class Project < ApplicationRecord
  enum status_code: [
    :created,
    :submitted,
    :verified,
    :queued,
    :assigned,
    :generated,
    :complete,
    :published
  ]

  has_many :images
  has_many :assets
end
