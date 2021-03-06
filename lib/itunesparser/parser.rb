require 'date'
require 'uri'
require 'nokogiri'
require 'itunesparser/track'
require 'itunesparser/playlist'

module ItunesParser
	class Parser

		def initialize(filepath) 
			raise IOError unless File.exist?(filepath)
			file = File.open(filepath)
			@doc = Nokogiri::XML(file)
		end

		def get_tracks
			validate_plist_format
			@doc.css('key:contains("Tracks") + dict dict').map do |node|
				create_track(node)
			end
		end

		def get_playlists
			@doc.css('key:contains("Playlists") + array > dict').map do |node|
				create_playlist(node)
			end
		end

		private
		def validate_plist_format
			plist_version = @doc.xpath('/*/@version').first
			raise ArgumentError, "XML file is not a valid Plist format" if plist_version.nil? || plist_version.value != '1.0'
		end

		def create_track(track_node)
			track = Track.new
			track.id = track_node.at('key:contains("Track ID") + integer').text.to_i
			track.artist = track_node.at('key:contains("Artist") + string').text
			track.name = track_node.at('key:contains("Name") + string').text
			track.composer = get_optional_string track_node, 'Composer'
			track.album = track_node.at('key:contains("Album") + string').text	
			track.genre = track_node.at('key:contains("Genre") + string').text
			track.kind = track_node.at('key:contains("Kind") + string').text
			track.size = track_node.at('key:contains("Size") + integer').text.to_i
			track.total_time = get_total_time(track_node)
			track.disc_number = track_node.at('key:contains("Disc Number") + integer').text.to_i
			track.disc_count = track_node.at('key:contains("Disc Count") + integer').text.to_i
			track.number = track_node.at('key:contains("Track Number") + integer').text.to_i
			track.count = track_node.at('key:contains("Track Count") + integer').text.to_i
			track.year = track_node.at('key:contains("Year") + integer').text.to_i
			track.date_modified = Date.parse track_node.at('key:contains("Date Modified") + date').text
			track.date_added = Date.parse track_node.at('key:contains("Date Added") + date').text
			track.bit_rate = track_node.at('key:contains("Bit Rate") + integer').text.to_i
			track.sample_rate = track_node.at('key:contains("Sample Rate") + integer').text.to_i
			track.play_count = track_node.at('key:contains("Play Count") + integer').text.to_i
			track.play_date_utc = Date.parse track_node.at('key:contains("Play Date UTC") + date').text
			track.skip_count = get_optional_integer(track_node, 'Skip Count')
			track.skip_date = get_optional_date(track_node, 'Skip Date')
			track.compilation = !!track_node.at('key:contains("Compilation") + true') 
			track.artwork_count = track_node.at('key:contains("Artwork Count") + integer').text.to_i
			track.persistent_id = track_node.at('key:contains("Persistent ID") + string').text
			track.track_type = track_node.at('key:contains("Track Type") + string').text
			track.location = URI.decode(track_node.at('key:contains("Location") + string').text)
			track.file_folder_count = track_node.at('key:contains("File Folder Count") + integer').text.to_i
			track.library_folder_count = track_node.at('key:contains("Library Folder Count") + integer').text.to_i
			track
		end

		def get_optional_string(track_node, name)
			node = track_node.at("key:contains(\"#{name}\") + string") 
			node.text unless node.nil?
		end

		def get_optional_integer(track_node, name)
			node = track_node.at("key:contains(\"#{name}\") + integer")
			node.text.to_i unless node.nil?
		end

		def get_optional_date(track_node, name) 
			node = track_node.at("key:contains(\"#{name}\") + date")
			Date.parse node.text unless node.nil?
		end

		def get_total_time track_node
			milliseconds = track_node.at('key:contains("Total Time") + integer').text.to_i
			Time.at(milliseconds/1000).strftime('%#M:%S').sub!(/^0/, "")
		end

		def create_playlist playlist_node
			playlist = Playlist.new
			playlist.name = playlist_node.at('key:contains("Name") + string').text
			playlist.id = playlist_node.at('key:contains("Playlist ID") + integer').text.to_i
			playlist.persistent_id = playlist_node.at('key:contains("Persistent ID") + string').text
			playlist.track_ids = parse_track_ids(playlist_node.at('key:contains("Playlist Items") + array'))
			playlist
		end

		def parse_track_ids(array_node) 
			array_node.css('key:contains("Track ID") + integer').map do |int_node|
				int_node.text.to_i
			end
		end
	end
end
