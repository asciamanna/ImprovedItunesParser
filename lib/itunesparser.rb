require 'rubygems'
require 'bundler/setup'
require 'itunesparser/track'
require 'itunesparser/playlist'
require 'itunesparser/parser'

module ItunesParser
	@parser
	class << self
		def create(filepath) 
			@parser = Parser.new(filepath)
		end

		def get_tracks
			@parser.get_tracks
		end

		def get_playlists
			@parser.get_playlists
		end
	end
end
