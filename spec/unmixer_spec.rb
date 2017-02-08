require "spec_helper"

module UnmixerTest; end

module MixerM1; end
module MixerM2; end
module MixerM3; end
module MixerM4; end
module MixerM5; end
module MixerM6; end
module MixerM7; end
module MixerM8; end
module MixerM9; end
module MixerM10; end

using Unmixer

RSpec.describe Unmixer do
	shared_examples_for "モジュールが削除される" do |mod|
		it { expect { subject.call mod }.to change { klass.ancestors.size }.by(-1) }
		it { expect { subject.call mod }.to change { klass.ancestors.include? mod }.from(true).to(false) }
		it { expect { subject.call mod }.to_not change { klass.superclass.ancestors } }
	end

	shared_examples_for "モジュールが削除されない" do |mod|
		it { expect { subject.call mod }.to_not change { klass.ancestors } }
		it { expect { subject.call mod }.to_not raise_error }
	end

	shared_examples_for "モジュールの削除" do |mod|
		subject { -> mod { remove_module.call mod } }

		it_behaves_like "モジュールが削除される", mod

		context "組み込みのモジュールを指定する" do
			it_behaves_like "モジュールが削除されない", Kernel
			it_behaves_like "モジュールが削除されない", Enumerable
		end

		context "モジュール以外を渡す" do
			it { expect { subject.call 42 }.to raise_error(TypeError) }
			it { expect { subject.call Object }.to raise_error(TypeError) }
		end
	end

	let(:klass) {
		Class.new(Class.new {
			prepend MixerM1
			include MixerM2
		}) {
			include MixerM3
			include MixerM4
			prepend MixerM5
			prepend MixerM6

			include Module.new {
				include MixerM7
				prepend MixerM8
			}

			prepend Module.new {
				include MixerM9
				prepend MixerM10
			}
		}
	}

	context "Module#unmixin" do
		subject(:subject){ -> mod { klass.instance_eval { unmixin mod } } }

		context "スーパークラスで mixin したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", MixerM1
			it_behaves_like "モジュールが削除されない", MixerM2
		end

		context "include したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM3
			it_behaves_like "モジュールが削除される", MixerM4
		end

		context "prepend したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM5
			it_behaves_like "モジュールが削除される", MixerM6
		end

		context "include したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM7
			it_behaves_like "モジュールが削除される", MixerM8
		end

		context "prepend したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM9
			it_behaves_like "モジュールが削除される", MixerM10
		end

		context "組み込みのモジュールを指定した場合" do
			it_behaves_like "モジュールが削除されない", Kernel
		end

		context "モジュール以外を渡した場合" do
			it { expect { subject.call 42 }.to raise_error(TypeError) }
			it { expect { subject.call Object }.to raise_error(TypeError) }
			it { expect { subject.call klass }.to raise_error(TypeError) }
			it { expect { subject.call klass.superclass }.to raise_error(TypeError) }
		end
	end

	context "#uninclude" do
		subject(:subject){ -> mod { klass.instance_eval { uninclude mod } } }

		context "スーパークラスで mixin したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", MixerM1
			it_behaves_like "モジュールが削除されない", MixerM2
		end

		context "include したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM3
			it_behaves_like "モジュールが削除される", MixerM4
		end

		context "prepend したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", MixerM5
			it_behaves_like "モジュールが削除されない", MixerM6
		end

		context "include したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM7
			it_behaves_like "モジュールが削除される", MixerM8
		end

		context "prepend したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", MixerM9
			it_behaves_like "モジュールが削除されない", MixerM10
		end

		context "組み込みのモジュールを指定した場合" do
			it_behaves_like "モジュールが削除されない", Kernel
		end

		context "モジュール以外を渡した場合" do
			it { expect { subject.call 42 }.to_not raise_error }
			it { expect { subject.call Object }.to_not raise_error }
			it { expect { subject.call klass }.to_not raise_error }
			it { expect { subject.call klass.superclass }.to_not raise_error }
		end
	end

	context "#unprepend" do
		subject(:subject){ -> mod { klass.instance_eval { unprepend mod } } }

		context "スーパークラスで mixin したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", MixerM1
			it_behaves_like "モジュールが削除されない", MixerM2
		end

		context "include したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", MixerM3
			it_behaves_like "モジュールが削除されない", MixerM4
		end

		context "prepend したモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM5
			it_behaves_like "モジュールが削除される", MixerM6
		end

		context "include したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除されない", MixerM7
			it_behaves_like "モジュールが削除されない", MixerM8
		end

		context "prepend したモジュールが mixin しているモジュールを渡した場合" do
			it_behaves_like "モジュールが削除される", MixerM9
			it_behaves_like "モジュールが削除される", MixerM10
		end

		context "組み込みのモジュールを指定した場合" do
			it_behaves_like "モジュールが削除されない", Kernel
		end

		context "モジュール以外を渡した場合" do
			it { expect { subject.call 42 }.to_not raise_error }
			it { expect { subject.call Object }.to_not raise_error }
			it { expect { subject.call klass }.to_not raise_error }
			it { expect { subject.call klass.superclass }.to_not raise_error }
		end
	end

	context "#unextend" do
		let(:obj){
			Class.new {
				extend  MixerM1
				include MixerM2
			}
		}
		let(:klass) {
			obj.singleton_class
		}

		subject{ -> mod { obj.unextend mod } }

		it { expect(subject.call MixerM1).to eq obj }
		it { expect(subject.call MixerM2).to eq obj }
		it_behaves_like "モジュールが削除される", MixerM1
		it_behaves_like "モジュールが削除されない", MixerM2

		context "ブロックを渡した場合" do
			let(:obj){
				Class.new {
					extend MixerM1
				}
			}

			before do
				@result = obj.singleton_class.ancestors
			end
			subject { -> mod { obj.unextend(mod){ @result = obj.singleton_class.ancestors } } }

			it { expect(obj.unextend(MixerM1){ 42 }).to eq obj }
			it { expect(obj.unextend(MixerM2){ 42 }).to eq obj }

			context "extend してるモジュールを渡した場合" do
				it { expect { subject.call MixerM1 }.to change { @result.size }.by(-1) }
				it { expect { subject.call MixerM1 }.to change { @result.include? MixerM1 }.from(true).to(false) }
			end

			context "extend していないモジュールを渡した場合" do
				let(:klass){ obj.singleton_class }
				it { expect { subject.call MixerM2 }.to_not change { klass.ancestors } }
			end

			let(:klass){ obj.singleton_class }
			it_behaves_like "モジュールが削除されない", MixerM1

			context "ブロック内で break した場合" do
				subject { -> { obj.unextend(MixerM1){ break 42 } } }
				it { expect(subject.call).to eq 42 }
				it { is_expected.to_not change { obj.singleton_class.ancestors } }
			end

			context "ブロック内で例外が発生した場合" do
				subject { -> { obj.unextend(MixerM1){ raise } } }
				it { is_expected.to raise_error  }
				it { expect {
					begin
						subject.call
					rescue
					end
				}.to_not change { obj.singleton_class.ancestors } }

			end
		end
	end

	context "#extend" do
		context "ブロックを渡した場合" do
			let(:obj){
				Class.new {
				}
			}
			it { expect(obj.extend(MixerM1){ 42 }).to eq obj }
			subject { -> mod { obj.extend(mod){ @result = obj.singleton_class.ancestors } } }

			before do
				@result = obj.singleton_class.ancestors
			end
			it { expect { subject.call MixerM1 }.to change { @result.size }.by(1) }
			it { expect { subject.call MixerM1 }.to change { @result.include? MixerM1 }.from(false).to(true) }

			it { expect { subject.call MixerM1 }.to_not change { obj.singleton_class.ancestors } }

			context "ブロック内で break した場合" do
				subject { -> { obj.extend(MixerM1){ break 42 } } }
				it { expect(subject.call).to eq 42 }
				it { is_expected.to_not change { obj.singleton_class.ancestors } }
			end

			context "すでに mixin されてるモジュールを指定した場合" do
				before do
					obj.extend(MixerM1)
				end

				it { expect { subject.call MixerM1 }.to change { @result.size }.by(1) }
				it { expect { subject.call MixerM1 }.to change { @result.include? MixerM1 }.from(false).to(true) }
				it { expect { subject.call MixerM1 }.to change { obj.singleton_class.ancestors.include? MixerM1 }.from(true).to(false) }
			end

			context "ブロック内で例外が発生した場合" do
				subject { -> { obj.extend(MixerM1){ raise "test" } } }
				it { is_expected.to raise_error "test" }
				it { expect {
					begin
						subject.call
					rescue
					end
				}.to_not change { obj.singleton_class.ancestors } }

			end
		end
	end
end
