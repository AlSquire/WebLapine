require 'open-uri'

class Link < ActiveRecord::Base
  scope :search, lambda { |term| where(arel_table[:line].matches("%#{term.strip}%")) }

  validates_presence_of :network, :channel, :sender, :line

  after_create :mirror_image!, :if => :image?
  after_create :mirror_imgur!, :if => :imgur?

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

  def imgur_image_uri
    @imgur_image_uri ||= Nokogiri::HTML(open(uri)).css('head > link[rel=image_src]').first.attr('href')
  end

  private
  def mirror_image!
    mirror_uri = self.class.request_resource_mirroring(uri)
    update_attribute(:mirror_uri, mirror_uri) if mirror_uri
  end

  def mirror_imgur!
    mirror_uri = self.class.request_resource_mirroring(imgur_image_uri)
    update_attribute(:mirror_uri, mirror_uri) if mirror_uri
  end
end
