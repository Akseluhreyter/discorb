require "rspec"
require "discorb"

RSpec.describe "Discorb::Dictionary" do
  let(:dict) {
    Discorb::Dictionary.new(
      { foo: :bar, fizz: :buzz, hoge: :fuga }
    )
  }
  context ".new" do
    it "creates an empty dictionary" do
      expect { Discorb::Dictionary.new }.to_not raise_error
    end
    it "creates with elements" do
      expect {
        Discorb::Dictionary.new(
          { foo: :bar, fizz: :buzz }
        )
      }.to_not raise_error
    end
  end
  context "#[]" do
    it "transforms non-string keys to strings" do
      expect(dict[:foo]).to be :bar
      expect(dict["foo"]).to be :bar
    end
    it "returns value with integer index" do
      expect(dict[0]).to be :bar
    end
    it "sorts keys" do
      new_dict = Discorb::Dictionary.new(
        { hoge: :fuga, foo: :bar, fizz: :buzz },
        sort: proc { |a, b| a.to_s },
      )
      expect(new_dict[0]).to be :buzz
      new_dict[:a] = :b
      expect(new_dict[0]).to be :b
    end
    it "follows limits" do
      new_dict = Discorb::Dictionary.new(
        { hoge: :fuga, foo: :bar, fizz: :buzz },
        limit: 4,
      )
      expect(new_dict.size).to eq 3
      new_dict[:a] = :b
      new_dict[:b] = :c
      expect(new_dict.size).to eq 4
    end
  end
  context "#to_h" do
    it "returns hash" do
      expect(dict.to_h).to eq({
        "foo" => :bar,
        "fizz" => :buzz,
        "hoge" => :fuga,
      })
    end
  end
  context "#values" do
    it "returns values" do
      expect(dict.values).to eq [:bar, :buzz, :fuga]
    end
  end
  context "#has?" do
    it "should return true if value exists" do
      expect(dict.has?(:foo)).to be true
      expect(dict.has?("foo")).to be true
      expect(dict.has?(:bar)).to be false
    end
  end
  context "#merge" do
    it "merges dictionary" do
      dict2 = Discorb::Dictionary.new(
        { piyo: :poyo, fizz: :buzz2 }
      )
      dict.merge(dict2)
      expect(dict.to_h).to eq(
        { "foo" => :bar, "fizz" => :buzz2, "hoge" => :fuga, "piyo" => :poyo }
      )
    end
  end
  context "#remove" do
    it "removes item" do
      dict.remove("foo")
      expect(dict.to_h).to eq(
        { "fizz" => :buzz, "hoge" => :fuga }
      )
    end
  end
end
