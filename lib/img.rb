require 'rmagick'
# based in part on https://gist.github.com/edouard/1787879

class Img
  def self.load path
    Img.new Magick::Image.read(path).first
  end

  def method_missing(method, *args, &block)
    result = @image.send(method, *args, &block)
    (result.is_a? Magick::Image) ? Img.new(result) : result
  end

  def initialize image
    @image = image
  end

  def dominant_colors count=10
    quantized = Img.new @image.quantize(count, Magick::RGBColorspace)
    color_row = quantized.to_color_row
    color_row.to_color_palette
  end

  def to_color_palette
    pixels = @image.get_pixels(0, 0, @image.columns, 1)
    pixels.map do |p|
      p.to_color(Magick::AllCompliance, false, 8, true)
    end
  end

  # Create a 1-row image that has a column for every color in the quantized
  # image. The columns are sorted decreasing frequency of appearance in the
  # quantized image.
  def to_color_row
    hist = @image.color_histogram
    # sort by decreasing frequency
    sorted = hist.keys.sort_by {|p| -hist[p]}
    new_img = Magick::Image.new(hist.size, 1)
    Img.new new_img.store_pixels(0, 0, hist.size, 1, sorted)
  end
end
