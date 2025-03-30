class MessagesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!

  def create
    @message = Message.create(message_params.merge(chat_id: params[:chat_id], role: "user"))
    process_message_request
    respond_to do |format|
      format.turbo_stream
    end
  end

  private def message_params
    params.require(:message).permit(:content, :url, :image_action)
  end

  private def process_message_request
    if ["generate_image", "edit_image"].include?(image_action)
      attachment = create_image_attachment
      GenerateImageJob.perform_later(attachment.id)
    else
      GetAiResponseJob.perform_later(@message.chat_id)
    end
  end

  private def image_action
    params[:message][:image_action]
  end

  private def create_image_attachment
    url = self.params[:message][:url].present? ? self.params[:message][:url] : nil
    @message.attachments.create!(
      content_type: :image,
      prompt: self.params[:message][:content],
      metadata: {
        size: self.params[:size],
        quality: self.params[:quality],
        url: url
      }
    )
  end
end
