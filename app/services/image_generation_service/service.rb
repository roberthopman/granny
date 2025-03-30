module ImageGenerationService
  class Service
    class Error < StandardError; end

    ALLOWED_SIZES = ["1024x1024", "1792x1024", "1024x1792"].freeze
    ALLOWED_QUALITIES = ["standard", "hd"].freeze
    DEFAULT_SIZE = "1024x1024".freeze
    DEFAULT_QUALITY = "standard".freeze
    ACTIONS = { generate: "generate", edit: "edit" }.freeze

    def self.call(prompt:, source_image: nil, size: DEFAULT_SIZE, quality: DEFAULT_QUALITY, config: ImageGenerationService::Configuration.default)
      new(prompt: prompt, source_image: source_image, size: size, quality: quality, config: config).call
    end

    def initialize(prompt:, source_image: nil, size:, quality:, config:)
      validate_parameters!(prompt, size, quality)
      @prompt = prompt
      @source_image = source_image
      @size = size
      @quality = quality
      @config = config
    end

    def call
      response = if @source_image
        @config.client.images.edit(parameters: edit_parameters)
      else
        @config.client.images.generate(parameters: generation_parameters)
      end
      process_response(response)
    rescue OpenAI::Error => e
      raise Error, "Failed to generate image: #{e.message} (prompt: #{@prompt.truncate(50)})"
    rescue StandardError => e
      raise Error, "Unexpected error: #{e.message}"
    end

    private

    def validate_parameters!(prompt, size, quality)
      raise Error, "Prompt cannot be blank" if prompt.blank?
      raise Error, "Invalid size: #{size}" unless ALLOWED_SIZES.include?(size)
      raise Error, "Invalid quality: #{quality}" unless ALLOWED_QUALITIES.include?(quality)
    end

    def generation_parameters
      {
        model: @config.model,
        prompt: @prompt,
        size: @size,
        quality: @quality,
        n: 1
      }
    end

    def edit_parameters
      {
        image: download_image(@source_image),
        prompt: @prompt,
        n: 1,
        size: @size
      }
    end

    def download_image(url)
      require 'open-uri'
      require 'tempfile'
      require 'mini_magick'

      image_data = URI.open(url).read

      tempfile = Tempfile.new(['image', '.png'])
      tempfile.binmode
      tempfile.write(image_data)
      tempfile.rewind

      image = MiniMagick::Image.open(tempfile.path)
      image.format 'png'
      image.alpha 'set'

      output_path = tempfile.path.sub('.png', '_processed.png')
      image.write(output_path)

      processed_data = File.read(output_path)

      File.delete(output_path) if File.exist?(output_path)

      processed_tempfile = Tempfile.new(['processed_image', '.png'])
      processed_tempfile.binmode
      processed_tempfile.write(processed_data)
      processed_tempfile.rewind

      puts "--------------------------------"
      # openai accepts max 4MB, check if it's too big
      puts 'processed_tempfile'
      puts processed_tempfile.size
      puts processed_tempfile.size / 1024 / 1024
      puts "--------------------------------"

      processed_tempfile
    rescue OpenURI::HTTPError => e
      raise Error, "Failed to download image from URL: #{e.message}"
    end

    def process_response(response)
      puts "--------------------------------"
      puts 'response'
      puts response
      puts "--------------------------------"
      data = response.dig("data", 0)
      return { url: data["url"], revised_prompt: data["revised_prompt"] } if data&.dig("url").present?

      raise Error, "Failed to generate image: Invalid response format"
    end
  end
end
