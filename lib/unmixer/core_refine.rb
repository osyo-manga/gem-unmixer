require "unmixer/unmixer"

module Unmixer
	refine Module do
		alias_method :unmixin, :unmixer_unmixin

		def unmixer_uninclude mod, &block
			return self unless ancestors.tap { |it| break it[it.find_index(self)+1..it.find_index(superclass)-1] }.include? mod
			unmixer_unmixin mod
		end
		alias_method :uninclude, :unmixer_uninclude

		alias_method :unmixer_original_include, :include
		def unmixer_include mod
			unmixer_original_include mod
			
			if block_given?
				begin
					yield(self)
				ensure
					unmixer_uninclude mod
				end
			end
			self
		end
		alias_method :include, :unmixer_include


		def unmixer_unprepend mod
			return self unless ancestors.tap { |it| break it[0, it.find_index(self)] }.include? mod
			unmixer_unmixin mod

			if block_given?
				begin
					yield(self)
				ensure
					unmixer_original_extend mod
				end
			end
			self
		end
		alias_method :unprepend, :unmixer_unprepend

		alias_method :unmixer_original_prepend, :prepend
		def unmixer_prepend mod
			unmixer_original_prepend mod
			
			if block_given?
				begin
					yield(self)
				ensure
					unmixer_unprepend mod
				end
			end
			self
		end
		alias_method :prepend, :unmixer_prepend
	end

	refine Object do
		alias_method :unmixer_original_extend, :extend
		def unmixer_extend mod
			unmixer_original_extend mod
			
			if block_given?
				begin
					yield(self)
				ensure
					unmixer_unextend mod
				end
			end
			self
		end
		alias_method :extend, :unmixer_extend

		def unmixer_unextend mod
			return self unless singleton_class.ancestors.include? mod
			
			singleton_class.__send__ :unmixer_unmixin, mod

			# NOTE: 複数のモジュールが mixin されている場合、同じ位置に mixin 出来ない
# 			if block_given?
# 				begin
# 					yield(self)
# 				ensure
# 					unmixer_original_extend mod
# 				end
# 			end
			self
		end
		alias_method :unextend, :unmixer_unextend
	end
end
