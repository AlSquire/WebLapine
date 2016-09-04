require 'spec_helper'

describe LogTrack do
  it { is_expected.to belong_to(:log) }
end
