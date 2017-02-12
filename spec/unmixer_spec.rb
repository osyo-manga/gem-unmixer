require "spec_helper"

module UnmixerTest; end

module None; end
module SuperPrepend; end
module SuperInclude; end
module Include1; end
module Include2; end
module Prepend1; end
module Prepend2; end
module IncludeInclude; end
module IncludePrepend; end
module PrependInclude; end
module PrependPrepend; end
module Extend; end

using Unmixer

RSpec.describe Unmixer do
	let(:mixin?) { -> mod { klass.ancestors.include? mod } }

	shared_examples_for "モジュールが削除される" do |mod|
		subject { -> { unmixin.call mod } }
		it { expect(subject.call).to eq result }
		it { is_expected.to change { klass.ancestors.size }.by(-1) }
		it { is_expected.to change { mixin?.call mod }.from(true).to(false) }
		it { is_expected.to_not change { klass.superclass.ancestors } }
	end

	shared_examples_for "モジュールが削除されない" do |mod|
		subject { -> { unmixin.call mod } }
		it { expect(subject.call).to eq result }
		it { is_expected.to_not change { klass.ancestors } }
		it { is_expected.to_not raise_error }
	end

	shared_context "ブロックが呼ばれる" do |mod|
		subject { -> &block { unmixin.call mod, &block } }
		it { expect(subject.call {}).to eq result }
		it { expect(subject.call { break 42 }).to eq 42 }
		it { expect { subject.call {} }.to_not change{ klass.ancestors } }
		it { expect { subject.call { break 42 } }.to_not change{ klass.ancestors } }
		it { expect { subject.call { @result = 42 } }.to change{ @result }.from(nil).to(42) }
	end

	shared_context "ブロックが呼ばれない" do |mod|
		subject { -> &block { unmixin.call mod, &block } }
		it { expect(subject.call {}).to eq result }
		it { expect(subject.call { break 42 }).to eq result }
		it { expect { subject.call {} }.to_not change{ klass.ancestors } }
		it { expect { subject.call { break 42 } }.to_not change{ klass.ancestors } }
		it { expect { subject.call { @result = 42 } }.to_not change{ @result } }
	end

	let(:klass) {
		Class.new(Class.new {
			prepend SuperPrepend
			include SuperInclude
		}) {
			include Include1
			include Include2
			prepend Prepend1
			prepend Prepend2

			include Module.new {
				include IncludeInclude
				prepend IncludePrepend
			}

			prepend Module.new {
				include PrependInclude
				prepend PrependPrepend
			}
		}
	}
	subject(:result){ klass }

	context "Module#unmixin" do
		subject(:unmixin){ -> mod { klass.unmixin mod } }

		context "スーパークラスで mixin したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", SuperPrepend
			it_behaves_like "モジュールが削除されない", SuperInclude
		end

		context "include したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", Include1
			it_behaves_like "モジュールが削除される", Include2
		end

		context "prepend したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", Prepend1
			it_behaves_like "モジュールが削除される", Prepend2
		end

		context "include したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", IncludeInclude
			it_behaves_like "モジュールが削除される", IncludePrepend
		end

		context "prepend したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", PrependInclude
			it_behaves_like "モジュールが削除される", PrependPrepend
		end

		context "組み込みのモジュールを指定した場合" do
			it_behaves_like "モジュールが削除されない", Kernel
		end

		context "モジュール以外を渡した場合" do
			it { expect { unmixin.call 42 }.to raise_error(TypeError) }
			it { expect { unmixin.call Object }.to raise_error(TypeError) }
			it { expect { unmixin.call klass }.to raise_error(TypeError) }
			it { expect { unmixin.call klass.superclass }.to raise_error(TypeError) }
		end
	end

	context "#uninclude" do
		subject(:unmixin){ -> mod { klass.uninclude mod } }

		context "スーパークラスで mixin したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", SuperPrepend
			it_behaves_like "モジュールが削除されない", SuperInclude
		end

		context "include したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", Include1
			it_behaves_like "モジュールが削除される", Include2
		end

		context "prepend したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", Prepend1
			it_behaves_like "モジュールが削除されない", Prepend2
		end

		context "include したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", IncludeInclude
			it_behaves_like "モジュールが削除される", IncludePrepend
		end

		context "prepend したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", PrependInclude
			it_behaves_like "モジュールが削除されない", PrependPrepend
		end

		context "組み込みのモジュールを指定した場合" do
			it_behaves_like "モジュールが削除されない", Kernel
		end

		context "モジュール以外を渡した場合" do
			it { expect { unmixin.call 42 }.to_not raise_error }
			it { expect { unmixin.call Object }.to_not raise_error }
			it { expect { unmixin.call klass }.to_not raise_error }
			it { expect { unmixin.call klass.superclass }.to_not raise_error }
		end
	end

	context "#unprepend" do
		subject(:unmixin){ -> mod { klass.unprepend mod } }

		context "スーパークラスで mixin したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", SuperPrepend
			it_behaves_like "モジュールが削除されない", SuperInclude
		end

		context "include したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", Include1
			it_behaves_like "モジュールが削除されない", Include2
		end

		context "prepend したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", Prepend1
			it_behaves_like "モジュールが削除される", Prepend2
		end

		context "include したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", IncludeInclude
			it_behaves_like "モジュールが削除されない", IncludePrepend
		end

		context "prepend したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", PrependInclude
			it_behaves_like "モジュールが削除される", PrependPrepend
		end

		context "組み込みのモジュールを指定した場合" do
			it_behaves_like "モジュールが削除されない", Kernel
		end

		context "モジュール以外を渡した場合" do
			it { expect { unmixin.call 42 }.to_not raise_error }
			it { expect { unmixin.call Object }.to_not raise_error }
			it { expect { unmixin.call klass }.to_not raise_error }
			it { expect { unmixin.call klass.superclass }.to_not raise_error }
		end
	end

	context "#unextend" do
		let(:obj){
			Class.new {
				extend Extend
			}
		}
		let(:klass) {
			obj.singleton_class
		}
		subject(:result){ obj }

		subject(:unmixin){ -> mod, &block { obj.unextend mod, &block } }

		it { expect(subject.call Extend).to eq obj }
		it_behaves_like "モジュールが削除される", Extend

		it { expect(subject.call None).to eq obj }
		it_behaves_like "モジュールが削除されない", None

		context "ブロックを渡した場合" do
			it_behaves_like "ブロックが呼ばれる", Extend
			it_behaves_like "ブロックが呼ばれない", None
			it { expect { unmixin.call(Extend){ @result = mixin?.call Extend } }.to change{ @result }.from(nil).to(false) }
		end
	end

	context "#extend" do
		let(:obj){
			Class.new {
				extend Extend
			}
		}
		let(:klass) {
			obj.singleton_class
		}
		subject(:result){ obj }

		subject(:unmixin){ -> mod, &block { obj.extend mod, &block } }

		context "ブロックを渡した場合" do
			it_behaves_like "ブロックが呼ばれる", None
			it { expect { unmixin.call(None){ @result = mixin?.call None } }.to change{ @result }.from(nil).to(true) }
		end
	end
end
