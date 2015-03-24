require "open-uri"
require "RMagick"
require "logger"

class Cropped_image
  def initialize(params)
    @x = params['image_x'].to_f
    @y = params['image_y'].to_f
    @width = params['image_width'].to_f
    @height = params['image_height'].to_f
    @image = Magick::Image.from_blob(open(params['image_url']).read).first
    @filename = params['slug']
  end
  def crop
    # crop image according to crop parameters
    @image.crop!(@x * @image.columns, @y * @image.rows, @width * @image.columns, @height * @image.rows, true)
  end
  def resize
    @image.change_geometry!('560x400') { |cols, rows, img|
      img.resize!(cols, rows)
    }
    # TODO: resize and compress image, delete rmagick references
    # figure out a better naming convention than the slug
  end
  def cleanup
    # Set image to jpeg, remove comments and profile form the image
    @image.format = 'JPEG'
    @image.strip!
    # Compress image and write it to a file named after the petition slug
    @image.write(@filename) { self.quality = 85 }
  end
end