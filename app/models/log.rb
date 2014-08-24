class Log < ActiveRecord::Base
  has_many :log_tracks

  default_scope { order(arel_table[:created_at].desc) }
  scope :search_text, lambda { |term| where(arel_table[:line].matches("%#{term.strip}%")) }

  validates_presence_of :network, :channel, :sender, :line

  def self.random
    if count > 0
      log = limit(1).offset(rand(count)).first
      log.log_tracks.create
      log
    end
  end

  def self.previous(offset = 0)
    unscoped.joins(:log_tracks).order(LogTrack.arel_table[:created_at].desc).limit(1).offset(offset).first
  end
end
