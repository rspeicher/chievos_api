module Fixture
  def fixture(*args)
    File.read(File.expand_path("../../fixtures/#{File.join(args)}", __FILE__))
  end
end
