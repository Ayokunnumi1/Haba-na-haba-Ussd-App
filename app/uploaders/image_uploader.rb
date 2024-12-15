class ImageUploader < CarrierWave::Uploader::Base
  include ImageProcessing::MiniMagick

  process :convert_to_webp

  def convert_to_webp
    manipulate! do |img|
      img.format('webp') do |c|
        c.quality '80'
      end
    end
  end
end
