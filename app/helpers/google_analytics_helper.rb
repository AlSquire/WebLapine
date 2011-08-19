module GoogleAnalyticsHelper
  def google_analytics_id
    ENV['GOOGLE_ANALYTICS_ID']
  end

  def google_analytics
    if google_analytics_id.present?
      render :partial => '/google_analytics'
    end
  end
end
