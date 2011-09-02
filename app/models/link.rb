class Link < ActiveRecord::Base
  scope :search, lambda { |term| where(arel_table[:line].matches("%#{term.strip}%")) }

  validates_presence_of :network, :channel, :sender, :line
end
