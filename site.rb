# 
# well.. here is where the magic happens...
#

require 'active_record'
require 'sinatra'
require 'haml'
require 'sinatra/r18n'

set :haml, :format => :html5
set :blog_static_pages => "views/auto-generated-views/blog/"

def random_phrases
  @phrases = []
  @phrases << "how many times, can a man watch the sunrise, over his head without feeling free"
  @phrases << "Lazy days, crazy dolls"
  @phrases << "My heart is a pure sun and the sky is black"
  @phrases << "I can sit for hours here and watch the emerald feathers play"
  @phrases << "I can sit for hours here and watch the emerald feathers play"
  @phrases
end

R18n::I18n.default do |default|
  if R18n.available_locales.map(&:code).include?(request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first)
    default = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/[a-z]{2}/).first
  end
  default|= 'en'
end

class Site < Sinatra::Base
  
  register Sinatra::R18n
  set :root, File.dirname(__FILE__)

end

before do
  lang_found = request.path_info.scan(/[a-z]{2}/).first
  @locale = (R18n.available_locales.map(&:code).include?(lang_found)) ? lang_found : R18n::I18n.default
  @phrase = random_phrases.sample
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
    haml :blog_post, :locals => { :resource => filename }
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