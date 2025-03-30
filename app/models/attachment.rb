class Attachment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :message
  IMAGE_ACTIONS = [["generate_image", "Generate Image"], ["edit_image", "Edit Image"]]

  enum content_type: { image: 0, document: 1, audio: 2, video: 3 }
  enum status: { pending: 0, processing: 1, completed: 2, failed: 3 }

  validates :content_type, presence: true
  validates :status, presence: true
  validates :url, presence: true, if: :completed?

  after_create_commit -> { broadcast_created }
  after_update_commit -> { broadcast_updated }

  def broadcast_created
    broadcast_append_later_to(
      "#{dom_id(message.chat)}_messages",
      partial: "messages/attachment",
      locals: { attachment: self },
      target: dom_id(self)
    )
  end

  def broadcast_updated
    broadcast_replace_to(
      "#{dom_id(message.chat)}_messages",
      partial: "messages/attachment",
      locals: { attachment: self },
      target: dom_id(self)
    )
  end
end
