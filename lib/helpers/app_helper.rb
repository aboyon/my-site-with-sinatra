module SiteApp

  def self.random_phrases
    phrases = []
    phrases << "how many times, can a man watch the sunrise, over his head without feeling free"
    phrases << "Lazy days, crazy dolls"
    phrases << "My heart is a pure sun and the sky is black"
    phrases << "I can sit for hours here and watch the emerald feathers play"
  end

  def self.parse_post(filename)
    extension = File.extname(filename)
    case extension
      when '.haml'
        content = Nokogiri::HTML(Haml::Engine.new(File.read(filename)).render)
      when '.html'
        content = Nokogiri::HTML(File.read(filename))
    end
    post = {
      :created_at => File.ctime(filename),
      :link       => File.basename(filename, extension),
      :title      => content.xpath('//h3/text()').first.text,
      :preview    => content.xpath('//p/text()').first.text,
      :document   => content
    }
    post
  end

  def read_post(filename)
    if (File.exists?("#{filename}.haml"))
      content = Nokogiri::HTML(Haml::Engine.new(File.read("#{filename}.haml")).render)
    case extension
      when '.haml'
        content = Nokogiri::HTML(Haml::Engine.new(File.read(filename)).render)
      when '.html'
        content = Nokogiri::HTML(File.read(filename))
    end
  end

end