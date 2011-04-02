class Game
  def self.factory(method = :create, extras = {})
    args = {
      :name     => "Super Meat Boy",
      :guid     => rand(1_000_000).to_s,
      :title_id => rand(1_000_000).to_s,
    }
    send(method, args.merge(extras))
  end
end

class Achievement
  def self.factory(method = :create, extras = {})
    args = {
      :site_id => rand(1_000_000),
      :name    => "Achievement",
      :secret  => false,
      :value   => 50,
      :game    => Game.factory
    }
    send(method, args.merge(extras))
  end
end
