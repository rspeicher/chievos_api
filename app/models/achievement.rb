class Achievement < Ohm::Model
  include Ohm::Callbacks

  attribute :site_id
  attribute :name
  attribute :secret
  attribute :value
  attribute :uuid
  # TODO: Icon path
  reference :game, Game

  index :uuid

  before :validate, :set_uuid

  # Check if the achievement is a secret achievement
  def secret?
    secret == "true"
  end

  protected

  # Microsoft was not kind enough to give us a true UUID, so we're going to
  # fake one by combining this record's Game's UUID with the <tt>site_id</tt>
  def set_uuid
    self.uuid = "#{self.game.guid}::#{self.site_id}"
  end

  def validate
    super

    assert_present :game

    assert_present :site_id
    assert_present :name
    assert_present :secret
    assert_present :value
    assert_present :uuid

    assert_unique :uuid
  end
end