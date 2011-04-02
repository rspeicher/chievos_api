require 'spec_helper'

describe GamerTag, "#games" do
  before do
    FakeWeb.register_uri(:get, /GameCenter\?compareTo=saigoh/, :body => fixture('xbox_live/games_saigoh.html'))
    @resource = GamerTag.new('saigoh')
    @games    = @resource.games
  end

  it "should return an Array of GamerTag::Game instances" do
    @games.should be_kind_of(Array)
    @games[0].should be_kind_of(GamerTag::Game)
  end

  describe GamerTag::Game do
    subject { @games.detect { |g| g.name == "Super Meat Boy" } }

    it             { should_not be_nil }
    its(:name)     { should eql("Super Meat Boy") } # Redundant, but whatevs.
    its(:guid)     { should eql("66acd000-77fe-1000-9115-d80258410a5a") }
    its(:title_id) { should eql("1480657498") }
  end
end

describe GamerTag, "#achievements" do
  before do
    title_id = 1480657498 # Super Meat Boy
    FakeWeb.register_uri(:get, /Achievements\?.+titleId=#{title_id}/, :body => fixture("xbox_live/achievements_saigoh_#{title_id}.html"))
    @resource     = GamerTag.new('saigoh')
    @achievements = @resource.achievements(title_id)
  end

  it "should return an Array of GamerTag::Achievement instances" do
    @achievements.should be_kind_of(Array)
    @achievements[0].should be_kind_of(GamerTag::Achievement)
  end

  describe GamerTag::Achievement do
    context "normal achievement" do
      subject { @achievements.detect { |a| a.name == "The Real End" } }

      it              { should_not be_nil }
      its(:site_id)   { should eql("34") }
      its(:name)      { should eql("The Real End") }
      its(:secret)    { should eql(false) }
      its(:value)     { should eql("20") }
      its(:tile_path) { should eql("Ui/MH/0jc8P2NhbC82FQUXXFJRbjVBL2FjaC8wL0IAAAABUFBQ-SgjSQ==") }
    end

    context "secret achievement" do
      subject { @achievements.detect { |a| a.site_id == "28" } }

      it              { should_not be_nil }
      its(:site_id)   { should eql("28") }
      its(:name)      { should eql("Secret Achievement") }
      its(:secret)    { should eql(true) }
      its(:value)     { should eql("10") }
      its(:tile_path) { should eql("") }
    end
  end
end

