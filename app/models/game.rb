class Game < Ohm::Model
  attribute :name
  attribute :guid
  attribute :title_id
  list :achievements, Achievement

  index :guid
  index :title_id

  protected

  def validate
    super

    assert_present :name
    assert_present :guid
    assert_present :title_id

    assert_unique :guid
    assert_unique :title_id
  end
end
