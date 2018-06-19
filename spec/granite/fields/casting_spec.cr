{% for adapter in GraniteExample::ADAPTERS %}
module {{adapter.capitalize.id}}
  describe "{{ adapter.id }} #casting_to_fields" do
    it "casts string to int" do
      model = Review.new({ "downvotes" => "32" })
      model.downvotes.should eq 32
    end

    it "works with bytes" do
      model = HasBytes.new({"bytes" => Bytes.new(3, 3)})
      model.bytes.should eq Bytes.new(3,3)
    end

    it "generates an error if casting fails" do
      model = Review.new({ "downvotes" => "" })
      model.errors.size.should eq 1
    end

    it "compiles with empty fields" do
      model = Empty.new
      model.should_not be_nil
    end
  end
end
{% end %}
