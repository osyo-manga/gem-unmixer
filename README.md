[![Build Status](https://travis-ci.org/osyo-manga/gem-unmixer.svg?branch=master)](https://travis-ci.org/osyo-manga/gem-unmixer)

# Unmixer

Unmixer is removing mixin modules.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unmixer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unmixer

## Usage

```ruby
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
p X.ancestors.include? M1
# => false

# Not remove prepend module. #uninclude is only include modules.
X.instance_eval { uninclude M2 }
p X.ancestors
# => [M2, X, Object, Kernel, BasicObject]
p X.ancestors.include? M2
# => true


# Remove prepend module.
X.instance_eval { unprepend M2 }
p X.ancestors
# => [X, Object, Kernel, BasicObject]
p X.ancestors.include? M2
# => false


X.extend M3
p X.singleton_class.ancestors
# => [#<Class:X>, M3, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

# Remove extend module.
X.unextend M3
p X.singleton_class.ancestors
# => [#<Class:X>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
p X.singleton_class.ancestors.include? M3
# => false


# #extend with block
X.extend M1 do
	# mixin only in block.
	p X.singleton_class.ancestors
	# => [#<Class:X>, M1, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
end
p X.singleton_class.ancestors
# => [#<Class:X>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
p X.singleton_class.ancestors.include? M1
# => false

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/osyo-manga/gem-unmixer.


## Release Note

#### 0.3.0

* Fix accessibility `#unmixin`/`#uninclude`/`#unprepend` to public.
* Remove `#unextend` with block.

#### 0.2.0

* Fix `#extend`/`#unextend` result

#### 0.1.0
* Release

