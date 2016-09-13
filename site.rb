# 
# well.. here is where the magic happens...
#

$:.push File.expand_path('lib', __FILE__)

require 'rubygems'
require 'sinatra'
require 'haml'
require 'sinatra/r18n'
require 'digest'
require 'nokogiri'
require 'sinatra/paginate'

Dir["./lib/**/*.rb"].each { |f| require f }

set :haml, :format => :html5
set :views, "views"
set :blog_static_pages => "views/auto-generated-views/blog/"
set :default_language => "en"

before do
  url_lang = request.path_info.scan(/[a-z]{2}/).first
  @locale = (R18n.available_locales.map(&:code).include?(url_lang)) ? url_lang : settings.default_language
  @base_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  @blog_folder = "#{settings.blog_static_pages}/#{@locale}"
end

get '/' do
  redirect "/#{@locale}"
end

get '/:locale' do
  haml "#{params[:locale]}/index".to_sym
end

get '/:locale/blog' do

  file_list = Dir.entries(@blog_folder).reject { |file| %w(.. .).include?(filename) }.sort_by do |filename|
    File.ctime("#{@blog_folder}/#{filename}")
  end

  entries = []

  file_list.reverse.each do |filename|

    begin
      post = SiteApp.parse_post("#{@blog_folder}/#{filename}")
      next if post[:title].nil?
      entries << {
        :written  => post[:created_at],
        :link     => post[:link],
        :preview  => post[:preview],
        :title    => post[:title]
      }
    rescue => e
      @error = e.message
    end
  end

  if @error
    haml :rip_something
  else
    haml :blog_index, :locals => { :entries => entries }
  end
end

get '/:locale/blog/post/:slug' do
  post = SiteApp.read_post("#{@blog_folder}/#{params[:slug].downcase}")
  haml :not_found unless post.nil?
  @title = post[:title]
  haml :blog_post, :locals => {
    :permalink    => "#{@base_url}#{request.path_info}",
    :comment_hash => Digest::MD5.hexdigest(request.path_info),
    :title        => post[:title],
    :raw          => post[:raw],
    :created_at   => post[:created_at]
  }
end

get '/:locale/notes' do
  haml "#{params[:locale]}/notes".to_sym
end

not_found do
  haml :not_found
end