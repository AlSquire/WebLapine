class Link < ActiveRecord::Base
  scope :search, lambda { |term| where(arel_table[:line].matches("%#{term.strip}%")) }

  validates_presence_of :network, :channel, :sender, :line

  after_create :mirror_resource!, :if => :image?

  def self.request_resource_mirroring(uri)
    RestClient.post(ENV['MIRROR_SERVICE_URI'], :uri => uri) rescue false
  end

  def uri
    line.match(/(http[s]?:\/\/[^\s]+)/)[0]
  end

  def image?
    uri.end_with? *%w(.png .gif .jpg .jpeg)
  end

  private
  def mirror_resource!
    mirror_uri = self.class.request_resource_mirroring(uri)
    update_attribute(:mirror_uri, mirror_uri) if mirror_uri
  end
end
