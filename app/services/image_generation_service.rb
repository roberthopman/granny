require_relative 'image_generation_service/configuration'
require_relative 'image_generation_service/service'

module ImageGenerationService
  def self.call(**args)
    Service.call(**args)
  end
end
