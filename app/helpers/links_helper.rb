module LinksHelper
  # Sample youtube urls:
  #   http://www.youtube.com/watch?v=ZnehCBoYLbc
  #   http://www.youtube.com/watch?v=_O7iUiftbKU&feature=relmfu

  def youtube_video(video_id)
    "<iframe width=\"425\" height=\"349\" src=\"http://www.youtube.com/embed/#{video_id}\" frameborder=\"0\" allowfullscreen></iframe>".html_safe
  end

  def extract_youtube_id_from_url(url)
    CGI.parse(URI.parse(url).query)["v"].first
  end

  def detect_youtube_url(line)
    regexp = /http:\/\/www.youtube.com\/watch\?[^\s]*/
    match = line.match(regexp)
    match[0] if match
  end
end
