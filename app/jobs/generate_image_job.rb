class GenerateImageJob < ApplicationJob
  queue_as :default

  def perform(attachment_id)
    attachment = Attachment.find(attachment_id)
    attachment.processing!

    begin
      result = ImageGenerationService.call(
        prompt: attachment.prompt,
        size: attachment.metadata["size"],
        quality: attachment.metadata["quality"],
        source_image: attachment.metadata["url"] || nil
      )

      attachment.update!(
        status: :completed,
        url: result[:url],
        metadata: attachment.metadata.merge(
          revised_prompt: result[:revised_prompt]
        )
      )
    rescue StandardError => e
      attachment.update!(
        status: :failed,
        metadata: attachment.metadata.merge(
          error: e.message
        )
      )
      raise
    end
  end
end
