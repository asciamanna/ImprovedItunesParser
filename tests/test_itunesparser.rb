require 'date'
require 'uri'
require 'test/unit'
require './lib/itunesparser.rb'

class TestItunesParser < Test::Unit::TestCase
	def test_get_tracks_returns_all_tracks_from_library
		parser = ItunesParser.new(File.dirname(__FILE__) + "/sampleiTunesLibrary.xml")
		tracks = parser.get_tracks
		assert_equal(25, tracks.length)
	end

	def test_get_tracks_creates_a_complete_track_object
		expected_date_modified = Date.parse "2012-02-25T17:59:58Z"
		expected_date_added = Date.parse "2012-02-25T17:48:36Z"
		expected_play_date_utc = Date.parse "2012-08-15T21:04:59Z"
		expected_skip_date = Date.parse "2012-09-21T10:54:14Z"
		expected_location = "file://localhost/C:/Users/anthony/Music/iTunes/iTunes Music/Bill Evans & Jim Hall/Undercurrent/03 Dream Gypsy.m4a"
		

		parser = ItunesParser.new(File.dirname(__FILE__) + "/sampleiTunesLibrary.xml")
		track = parser.get_tracks.first
		assert_equal(17714, track.id)
		assert_equal('Dream Gypsy', track.name)
		assert_equal('Bill Evans & Jim Hall', track.artist)
		assert_equal('Judith Veevers', track.composer)
		assert_equal('Undercurrent', track.album)
		assert_equal('Jazz', track.genre)
		assert_equal('AAC audio file', track.kind)
		assert_equal(11550486, track.size)
		assert_equal('4:34', track.total_time)
		assert_equal(1, track.disc_number)
		assert_equal(1, track.disc_count)
		assert_equal(3, track.number)
		assert_equal(10, track.count)
		assert_equal(1962, track.year)
		assert_equal(expected_date_modified, track.date_modified)
		assert_equal(expected_date_added, track.date_added)
		assert_equal(320, track.bit_rate)
		assert_equal(44100, track.sample_rate)
		assert_equal(11, track.play_count)
		assert_equal(expected_play_date_utc, track.play_date_utc)
		assert_equal(3, track.skip_count)
		assert_equal(expected_skip_date, track.skip_date)
		assert(track.is_part_of_compilation?)
		assert_equal(1, track.artwork_count)
		assert_equal('C7B8EDD04F93004D', track.persistent_id)
		assert_equal('File', track.track_type)
		assert_equal(expected_location, track.location)
		assert_equal(4, track.file_folder_count)
		assert_equal(1, track.library_folder_count)
	end
end
