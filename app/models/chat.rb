class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  default_scope { order(created_at: :desc) }
end
