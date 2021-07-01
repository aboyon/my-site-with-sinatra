#config.ru
require 'rubygems'
require 'sinatra'
require 'rack'
require "#{File.dirname(__FILE__)}/site.rb"
run Sinatra::Application
