module ImageGenerationService
  Configuration = Struct.new(:client, :model) do
    def self.default
      new(
        client: OpenAI::Client.new,
        model: "dall-e-2"
      )
    end
  end
end
