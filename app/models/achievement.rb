class Achievement < Ohm::Model
  include Ohm::Callbacks

  attribute :site_id
  attribute :name
  attribute :secret
  attribute :value
  attribute :tile_path
  attribute :global_id
  reference :game, Game

  index :global_id

  before :validate, :set_global_id

  class << self
    # Returns a string suitable for use as a <tt>global_id</tt>
    # for an <tt>Achievement</tt>.
    def global_id(title_id, site_id)
      "#{title_id}-#{site_id}"
    end
  end

  # Check if the achievement is a secret achievement
  def secret?
    secret == "true"
  end

  protected

  # Microsoft was not kind enough to give us a true UUID, so we're going to
  # fake one by combining this record's Game's <tt>title_id</tt> with our <tt>site_id</tt>
  def set_global_id
    self.global_id = self.class.global_id(self.game.title_id, self.site_id)
  end

  def validate
    super

    assert_present :game

    assert_present :site_id
    assert_present :name
    assert_present :secret
    assert_present :value
    assert_present :global_id

    assert_unique :global_id
  end
end
