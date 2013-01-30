# 
# well.. here is where the magic happens...
#
require 'sinatra'
require_relative 'initializer'

set :haml, :format => :html5
set :blog_static_pages => "views/auto-generated-views/blog/"

before do
  lang_found = request.path_info.scan(/[a-z]{2}/).first
  @locale = (R18n.available_locales.map(&:code).include?(lang_found)) ? lang_found : R18n::I18n.default
  @phrase = SiteApp::random_phrases.sample
  @base_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
end

get '/' do
  redirect "/#{@locale}"
end

get '/:locale' do
  haml :index
end

get '/:locale/blog' do
  entries = []
  Dir.entries("#{settings.blog_static_pages}/#{@locale}").each do |filename|
    unless ["..","."].include?(filename)
      content = Haml::Engine.new(File.read("#{settings.blog_static_pages}/#{@locale}/#{filename}")).render
      title = content.scan(/<!\s*--(.*?)(--\>)/).first
      entries.push({
        :written => File.ctime("#{settings.blog_static_pages}/#{@locale}/#{filename}"),
        :link => File.basename(filename,'.haml'),
        :title => title.first,
        :preview => content.scan(/<!\s*--(.*?)(--\>)/).last.first
      }) unless title.nil?
    end
  end
  haml :blog_index, :locals => { 
    :entries => entries
  }
end

get '/:locale/blog/post/:slug' do
  filename = "#{settings.blog_static_pages}/#{@locale}/#{params[:slug].downcase}.haml";
  if File.exists?(filename) 
    haml :blog_post, :locals => { 
      :resource     => filename,
      :permalink    => "#{@base_url}#{request.path_info}",
      :comment_hash => Digest::MD5.hexdigest(request.path_info),
      :title        => params[:slug]
    }
  else
    haml :not_found
  end
end

get '/:locale/notes' do
  haml :notes
end

not_found do
  haml :not_found
end