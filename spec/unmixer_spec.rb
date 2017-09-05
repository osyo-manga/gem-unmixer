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
	shared_examples_for "モジュールが削除される" do |mod|
		subject { -> { unmixin mod } }
		it { expect(subject.call).to eq result }
		it { is_expected.to change { klass.ancestors.size }.by(-1) }
		it { is_expected.to change { klass.include? mod }.from(true).to(false) }
		it { is_expected.to_not change { klass.superclass.ancestors } }
	end

	shared_examples_for "モジュールが削除されない" do |mod|
		subject { -> { unmixin mod } }
		it { expect(subject.call).to eq result }
		it { is_expected.to_not change { klass.ancestors } }
		it { is_expected.to_not raise_error }
	end

	shared_context "ブロックが呼ばれる" do |mod|
		it { expect(subject.call(mod){}).to eq result }
		it { expect(subject.call(mod){ break 42 }).to eq 42 }
		it { expect { subject.call(mod){} }.to_not change{ klass.ancestors } }
		it { expect { subject.call(mod){ break 42 } }.to_not change{ klass.ancestors } }
		it { expect { subject.call(mod){ @result = 42 } }.to change{ @result }.from(nil).to(42) }
	end

	shared_context "ブロックが呼ばれない" do |mod|
		it { expect(subject.call(mod){}).to eq result }
		it { expect(subject.call(mod){ break 42 }).to eq result }
		it { expect { subject.call(mod){} }.to_not change{ klass.ancestors } }
		it { expect { subject.call(mod){ break 42 } }.to_not change{ klass.ancestors } }
		it { expect { subject.call(mod){ @result = 42 } }.to_not change{ @result } }
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
		def unmixin mod
			klass.unmixin mod
		end
# 		subject(:unmixin){ -> mod { klass.unmixin mod } }

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
			it { expect { unmixin 42 }.to raise_error(TypeError) }
			it { expect { unmixin Object }.to raise_error(TypeError) }
			it { expect { unmixin klass }.to raise_error(TypeError) }
			it { expect { unmixin klass.superclass }.to raise_error(TypeError) }
		end
	end

	context "#uninclude" do
		def unmixin mod
			klass.uninclude mod
		end

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
			it { expect { unmixin 42 }.to_not raise_error }
			it { expect { unmixin Object }.to_not raise_error }
			it { expect { unmixin klass }.to_not raise_error }
			it { expect { unmixin klass.superclass }.to_not raise_error }
		end
	end

	context "#unprepend" do
		def unmixin mod, &block
			klass.unprepend mod, &block
		end

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
			it { expect { unmixin 42 }.to_not raise_error }
			it { expect { unmixin Object }.to_not raise_error }
			it { expect { unmixin klass }.to_not raise_error }
			it { expect { unmixin klass.superclass }.to_not raise_error }
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

		def unmixin mod, &block
			obj.unextend mod, &block
		end

		it { expect(obj.unextend Extend).to eq obj }
		it_behaves_like "モジュールが削除される", Extend

		it { expect(obj.unextend None).to eq obj }
		it_behaves_like "モジュールが削除されない", None

# 		context "ブロックを渡した場合" do
# 			subject { -> mod, &block { obj.unextend mod, &block } }
# 			it_behaves_like "ブロックが呼ばれる", Extend
# 			it_behaves_like "ブロックが呼ばれない", None
# 			it { expect { unmixin(Extend){ @result = klass.include? Extend } }.to change{ @result }.from(nil).to(false) }
# 		end
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
		let(:result){ obj }

		context "ブロックを渡した場合" do
			subject { -> mod, &block { obj.extend mod, &block } }
			it { expect(subject.call(None)).to eq(obj) }
			it_behaves_like "ブロックが呼ばれる", None
			it { expect { subject.call(None){ @result = klass.include? None } }.to change{ @result }.from(nil).to(true) }

			it { expect {
				begin
					subject.call(None){ raise }
				rescue
				end
			}.to_not change{ klass.ancestors } }
		end
	end

	context "#include" do
		let(:klass) {
			Class.new
		}

		context "ブロックを渡した場合" do
			subject { -> mod, &block { klass.include mod, &block } }
			it_behaves_like "ブロックが呼ばれる", None
			it { expect(subject.call(None)).to eq(klass) }
			it { expect { subject.call(None){ @result = klass.ancestors.first == klass } }.to change{ @result }.from(nil).to(true) }
			it { expect { subject.call(None){ @result = klass.ancestors[1] == None } }.to change{ @result }.from(nil).to(true) }
			it { expect {
				begin
					subject.call(None){ raise }
				rescue
				end
			}.to_not change{ klass.ancestors } }
		end
	end

	context "#prepend" do
		let(:klass) {
			Class.new
		}

		context "ブロックを渡した場合" do
			subject { -> mod, &block { klass.prepend mod, &block } }
			it_behaves_like "ブロックが呼ばれる", None
			it { expect { subject.call(None){ @result = klass.ancestors.first == None } }.to change{ @result }.from(nil).to(true) }
			it { expect { subject.call(None){ @result = klass.ancestors[1] == klass } }.to change{ @result }.from(nil).to(true) }
			it { expect {
				begin
					subject.call(None){ raise }
				rescue
				end
			}.to_not change{ klass.ancestors } }
		end
	end
end
