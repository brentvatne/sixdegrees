describe SixDegrees::SocialGraph do
	
	describe "self#build" do
		it "returns an instance of SocialGraph" do
			SixDegrees::SocialGraph.build.should be_kind_of(SixDegrees::SocialGraph)
		end
	end	

end
