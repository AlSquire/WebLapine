xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "WebLapine: Les bons logs #{@network}/#{@channel}"
    xml.description "All ur logs are belong to WebLapine"
    xml.link url_for(:only_path => false, :format => nil)

    @logs.each do |log|
      xml.item do
        xml.title log.line
        xml.description "[#{log.created_at}] #{log.sender}> #{auto_link(h(log.line))}"
        xml.pubDate log.created_at.to_s(:rfc822)
        xml.guid log.id
      end
    end
  end
end