require 'open-uri'

class Link < ActiveRecord::Base
  scope :search, lambda { |term| where(arel_table[:line].matches("%#{term.strip}%")) }

  validates_presence_of :network, :channel, :sender, :line

  after_create :mirror_image!,   :if => :image?
  after_create :mirror_imgur!,   :if => :imgur?
  after_create :mirror_ninegag!, :if => :ninegag?

  def self.request_resource_mirroring(uri)
    RestClient.post(ENV['MIRROR_SERVICE_URI'], :uri => uri) rescue false
  end

  def uri
    line.match(/(http[s]?:\/\/[^\s]+)/)[0]
  end

  def image?
    uri.end_with? *%w(.png .gif .jpg .jpeg)
  end

  def imgur?
    uri.start_with?('http://imgur.com/')
  end

  def ninegag?
    uri.start_with?('http://9gag.com/gag/')
  end

  def imgur_image_uri
    @imgur_image_uri ||= get_imgur_image_uri
  end

  def ninegag_image_uri
    @ninegag_image_uri ||= get_ninegag_image_uri
  end

  # Tagged Not Safe For Work or Not Mind Safe
  def nws?
    nms? || line.split(' ').any? { |word| word.match(/^[^\w]?(nws|nsfw)[^\w]*$/i) }
  end

  # Tagged Not Mind Safe
  def nms?
    line.split(' ').any? { |word| word.match(/^[^\w]?(nms|nsfm)[^\w]*$/i) }
  end

  # Tagged as Spoiler
  def spoiler?
    # line.split(' ').any? { |word| word.match(/^(spoil|spoiler)[.?!:]*$/i) }
    line.split(' ').any? { |word| word.match(/^[^\w]?(spoil|spoiler|spoilers)[^\w]*$/i) }
  end

  private
  def mirror_image!
    mirror_uri = self.class.request_resource_mirroring(uri)
    update_column(:mirror_uri, mirror_uri) if mirror_uri
  end

  def mirror_imgur!
    if imgur_image_uri
      mirror_uri = self.class.request_resource_mirroring(imgur_image_uri)
      update_column(:mirror_uri, mirror_uri) if mirror_uri
    end
  end

  def mirror_ninegag!
    if ninegag_image_uri
      mirror_uri = self.class.request_resource_mirroring(ninegag_image_uri)
      update_column(:mirror_uri, mirror_uri) if mirror_uri
    end
  end

  def get_imgur_image_uri
    @imgur_doc ||= Nokogiri::HTML(open(uri))
    tag = @imgur_doc.css('head > link[rel=image_src]').first
    tag.attr('href') if tag
  end

  def get_ninegag_image_uri
    @ninegag_doc ||= Nokogiri::HTML(open(uri))
    tag = @ninegag_doc.css('#content > .post-container > .img-wrap > img').first
    tag.attr('src') if tag
  end
end
