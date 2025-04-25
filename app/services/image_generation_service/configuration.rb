module ImageGenerationService
  Configuration = Struct.new(:client, :model) do
    def self.default
      new(
        client: OpenAI::Client.new,
        model: "gpt-image-1"
      )
    end
  end
end
