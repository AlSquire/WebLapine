# coding: utf-8
require 'spec_helper'

describe Log do
  it { is_expected.to have_many(:log_tracks) }

  it { is_expected.to validate_presence_of(:network) }
  it { is_expected.to validate_presence_of(:channel) }
  it { is_expected.to validate_presence_of(:sender) }
  it { is_expected.to validate_presence_of(:line) }

  let(:lines) do
    ["Lorem ipsum", "A la claire fontaine", "Claire habite à Lorient"]
  end

  let(:logs) do
    lines.map do |line|
      Log.create(:line => line, :network => "netnet", :channel => "chanchan", :sender => "xand")
    end
  end

  it { expect(described_class).to respond_to(:search_text) }
  describe ".search_text" do
    before do
      logs # So they are created in DB
    end

    it { expect(Log.search_text('claire').count).to eq(2) }
    it { expect(Log.search_text('lor').count).to eq(2) }
    it { expect(Log.search_text('  L  ').count).to eq(3) }
    it { expect(Log.search_text('kamehameha').count).to eq(0) }
  end

  it { expect(described_class).to respond_to(:random) }
  describe ".random" do
    before do
      logs # So they are created in DB
    end

    it do
      10.times do # Still random, should be better way to test it with mocks
        expect(logs).to include(Log.random)
      end
    end

    it do
      log = Log.random
      expect(LogTrack.last.log).to eq(log)
    end
  end

  it { expect(Log.random).to be_nil } # Without anything in DB

  it { expect(described_class).to respond_to(:previous) }
  describe ".previous" do
    before do
      logs[1].log_tracks.create
      logs[0].log_tracks.create
      logs[2].log_tracks.create
    end

    it do
      expect(Log.previous).to eq(logs[2])
    end

    it do
      expect(Log.previous(1)).to eq(logs[0])
    end

    it do
      expect(Log.previous(2)).to eq(logs[1])
    end
  end
end
