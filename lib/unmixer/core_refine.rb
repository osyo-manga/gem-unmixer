require "unmixer/unmixer"

module Unmixer
	refine Module do
		private
		alias_method :unmixin,   :unmixer_unmixin

		def unmixer_uninclude mod, &block
			return unless ancestors.tap { |it| break it[it.find_index(self)+1..it.find_index(superclass)-1] }.include? mod
			unmixer_unmixin mod
		end
		alias_method :uninclude, :unmixer_uninclude

		def unmixer_unprepend mod
			return unless ancestors.tap { |it| break it[0, it.find_index(self)] }.include? mod
			unmixer_unmixin mod
		end
		alias_method :unprepend, :unmixer_unprepend
	end

	refine Object do
		alias_method :unmixer_original_extend, :extend
		def unmixer_extend mod
			unmixer_original_extend mod
			
			if block_given?
				yield(self)
				unmixer_unextend mod
			end
		end
		alias_method :extend, :unmixer_extend

		def unmixer_unextend mod
			return unless singleton_class.ancestors.include? mod
			
			singleton_class.__send__ :unmixer_unmixin, mod

			if block_given?
				yield(self)
				unmixer_original_extend mod
			end
		end
		alias_method :unextend, :unmixer_unextend
	end
end
