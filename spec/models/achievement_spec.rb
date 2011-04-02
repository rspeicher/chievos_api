require 'spec_helper'

describe Achievement do
  subject { Achievement.factory }

  it { should be_valid }
end

describe Achievement, "#secret?" do
  subject { Achievement.factory }

  it "should return false if not secret" do
    subject.update(:secret => "false")
    subject.should_not be_secret
  end

  it "should return true if secret" do
    subject.update(:secret => "true")
    subject.should be_secret
  end
end
