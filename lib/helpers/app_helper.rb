module SiteApp

  def self.parse_post(filename)
    extension = File.extname(filename)
    case extension
      when '.haml'
        raw = Haml::Engine.new(File.read(filename).force_encoding('utf-8')).render
        content = Nokogiri::HTML(raw)
      when '.html'
        raw = File.read(filename).force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
        content = Nokogiri::HTML(raw)
    end
    post = {
      :created_at => File.ctime(filename),
      :link       => File.basename(filename, extension),
      :title      => content.xpath('//h3/text()').first.text,
      :preview    => content.xpath('//p').first.text,
      :raw        => raw
    }
    post
  end

  def self.read_post(filename)
    if (File.exists?("#{filename}.haml"))
      self.parse_post("#{filename}.haml")
    elsif (File.exists?("#{filename}.html"))
      self.parse_post("#{filename}.html")
    else
      nil
    end
  end

end