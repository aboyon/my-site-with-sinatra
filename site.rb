# 
# well.. here is where the magic happens...
#
require 'sinatra'
require 'haml'
require 'sinatra/r18n'
require 'digest'
require 'nokogiri'
require 'sinatra/paginate'

set :haml, :format => :html5
set :blog_static_pages => "views/auto-generated-views/blog/"
set :default_language => "en"

before do
  url_lang = request.path_info.scan(/[a-z]{2}/).first
  @locale = (R18n.available_locales.map(&:code).include?(url_lang)) ? url_lang : settings.default_language
  @base_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
end

get '/' do
  redirect "/#{@locale}"
end

get '/:locale' do
  haml "#{@locale}/index".to_sym
end

get '/:locale/blog' do
  entries = []
  file_list = Dir.entries("#{settings.blog_static_pages}/#{@locale}").sort_by{ |filename| File.ctime("#{settings.blog_static_pages}/#{@locale}/#{filename}") }
  file_list.reject! { |f| ["..","."].include?(f) }
  file_list.reverse.each do |filename|
      post = SiteApp.parse_post("#{settings.blog_static_pages}/#{@locale}/#{filename}")
      entries << {
        :written  => post[:created_at],
        :link     => post[:link],
        :preview  => post[:preview],
        :title    => post[:title]
      } unless post[:title].nil?
  end
  haml :blog_index, :locals => { :entries => entries }
end

get '/:locale/blog/post/:slug' do
  post = SiteApp.read_post("#{settings.blog_static_pages}/#{@locale}/#{params[:slug].downcase}")
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
  haml "#{@locale}/notes".to_sym
end

not_found do
  haml :not_found
end