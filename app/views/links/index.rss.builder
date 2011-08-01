xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "WebLapine: Les bons liens #{@network}/#{@channel}"
    xml.description "All ur links are belong to WebLapine"
    xml.link url_for(:only_path => false, :format => nil)

    @links.each do |link|
      if youtube_url = detect_youtube_url(link.line)
        youtube_div = content_tag(:div, youtube_video(extract_youtube_id_from_url(youtube_url)))
      end
      xml.item do
        xml.title link.line
        xml.description "[#{link.created_at}] #{link.sender}> #{auto_link(h(link.line))} #{youtube_div}"
        xml.pubDate link.created_at.to_s(:rfc822)
        # xml.link post_url(post)
        xml.guid link.id
      end
    end
  end
end