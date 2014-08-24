# coding: utf-8
require 'spec_helper'

describe Log do
  it { should have_many(:log_tracks) }

  it { should validate_presence_of(:network) }
  it { should validate_presence_of(:channel) }
  it { should validate_presence_of(:sender) }
  it { should validate_presence_of(:line) }

  let(:lines) do
    ["Lorem ipsum", "A la claire fontaine", "Claire habite à Lorient"]
  end

  let(:logs) do
    lines.map do |line|
      Log.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
    end
  end

  it { described_class.should respond_to(:search_text) }
  describe ".search_text" do
    before do
      logs # So they are created in DB
    end

    it { Log.search_text('claire').count.should == 2 }
    it { Log.search_text('lor').count.should == 2 }
    it { Log.search_text('  L  ').count.should == 3 }
    it { Log.search_text('kamehameha').count.should == 0 }
  end

  it { described_class.should respond_to(:random) }
  describe ".random" do
    before do
      logs # So they are created in DB
    end

    it do
      10.times do # Still random, should be better way to test it with mocks
        logs.should include(Log.random)
      end
    end

    it do
      log = Log.random
      LogTrack.last.log.should == log
    end
  end

  it { Log.random.should be_nil } # Without anything in DB

  it { described_class.should respond_to(:previous) }
  describe ".previous" do
    before do
      logs[1].log_tracks.create
      logs[0].log_tracks.create
      logs[2].log_tracks.create
    end

    it do
      Log.previous.should == logs[2]
    end

    it do
      Log.previous(1).should == logs[0]
    end

    it do
      Log.previous(2).should == logs[1]
    end
  end
end
