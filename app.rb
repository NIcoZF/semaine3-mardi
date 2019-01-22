require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'scrapper' #plus besoin de préciser le path exact


Scrapper.new.perform
