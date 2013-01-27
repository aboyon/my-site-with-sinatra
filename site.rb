# 
# well.. here is where the magic happens...
#

require 'active_record'
require 'sinatra'
require 'haml'
require 'sinatra/r18n'

set :haml, :format => :html5
set :allowed_lang => ["en",""]

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
  haml :blog_index
end

get '/blog/post/:slug' do
  filename = "views/auto-generated-views/#{params[:slug].downcase}.haml";
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