require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the GoogleAnalyticsHelper. For example:
#
# describe GoogleAnalyticsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe GoogleAnalyticsHelper do
  describe 'google_analytics' do
    it 'with google_analytics_id' do
      helper.stub(:google_analytics_id).and_return 'UA-12345678-1'
      helper.google_analytics.should_not be_blank
    end

    it 'without google_analytics_id' do
      helper.stub(:google_analytics_id).and_return nil
      helper.google_analytics.should be_blank
    end
  end

  describe 'google_analytics_id' do
    it do
      ENV.stub(:[]).with('GOOGLE_ANALYTICS_ID').and_return(nil)
      helper.google_analytics_id.should == nil
    end

    it do
      ENV.stub(:[]).with('GOOGLE_ANALYTICS_ID').and_return('UA-12345678-1')
      helper.google_analytics_id.should == 'UA-12345678-1'
    end
  end
end
