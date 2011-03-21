class Link < ActiveRecord::Base
  validates_presence_of :network, :channel, :line
end
