describe SixDegrees::SocialGraph do
  subject { SixDegrees::SocialGraph.new(users) }
  let(:users) { SixDegrees::TwitterParser.parse(tweets) }

  describe "acceptance test" do
    let(:tweets) { File.open(Dir.pwd + "/docs/sample_input.txt").read }

    it "correctly identifies first order connections in the sample file" do
      subject.first_order_connection?("alberta", "bob").should be_true
      subject.first_order_connection?("alberta", "christie").should be_true

      subject.first_order_connection?("bob", "alberta").should be_true
      subject.first_order_connection?("bob", "christie").should be_true
      subject.first_order_connection?("bob", "duncan").should be_true

      subject.first_order_connection?("christie", "alberta").should be_true
      subject.first_order_connection?("christie", "bob").should be_true
      subject.first_order_connection?("christie", "emily").should be_true

      subject.first_order_connection?("duncan", "bob").should be_true
      subject.first_order_connection?("duncan", "emily").should be_true
      subject.first_order_connection?("duncan", "farid").should be_true

      subject.first_order_connection?("emily", "christie").should be_true
      subject.first_order_connection?("emily", "duncan").should be_true

      subject.first_order_connection?("farid", "duncan").should be_true
    end
  end

  describe "first order connections" do
    let(:tweets) {
      'bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta @christie' + "\n" +
      'alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books. /cc @christie' + "\n" +
      'christie: @bob so I see it is Emerson tonight' + "\n" }

    it "correctly identifies first order connections" do
      subject.first_order_connection?("alberta", "bob").should be_true

      subject.first_order_connection?("bob", "alberta").should be_true
      subject.first_order_connection?("bob", "christie").should be_true
    end
  end
end
