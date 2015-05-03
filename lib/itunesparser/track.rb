class Track
	attr_accessor :id, :name, :artist, :composer, :album, :genre, :kind, :size, :total_time, :disc_number,
		:disc_count, :number, :count, :year, :date_modified, :date_added, :bit_rate, :sample_rate,
		:play_count, :play_date_utc, :skip_count, :skip_date, :artwork_count, :persistent_id,
		:track_type, :location, :file_folder_count, :library_folder_count

	attr_writer :compilation

	def is_part_of_compilation?
		@compilation
	end
end
