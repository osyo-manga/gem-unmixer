require "unmixer"

# unmixer is using refinements.
using Unmixer

module M1; end
module M2; end
module M3; end

class X
	include M1
	prepend M2
end

p X.ancestors
# => [M2, X, M1, Object, Kernel, BasicObject]

# Remove include module.
X.instance_eval { uninclude M1 }
p X.ancestors
# => [M2, X, Object, Kernel, BasicObject]

# Not remove prepend module. #uninclude is only include modules.
X.instance_eval { uninclude M2 }
p X.ancestors
# => [M2, X, Object, Kernel, BasicObject]


# Remove prepend module.
X.instance_eval { unprepend M2 }
p X.ancestors
# => [X, Object, Kernel, BasicObject]


X.extend M3
p X.singleton_class.ancestors
# => [#<Class:X>, M3, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

# Remove extend module.
X.unextend M3
p X.singleton_class.ancestors
# => [#<Class:X>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]


# #extend with block
X.extend M1 do
	# mixin only in block.
	p X.singleton_class.ancestors
	# => [#<Class:X>, M1, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
end
p X.singleton_class.ancestors
# => [#<Class:X>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

