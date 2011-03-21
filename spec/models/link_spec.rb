require 'spec_helper'

describe Link do
  it { should validate_presence_of(:network) }
  it { should validate_presence_of(:channel) }
  it { should validate_presence_of(:line) }
end
