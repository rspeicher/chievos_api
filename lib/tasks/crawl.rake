namespace :crawl do
  desc "Crawl saigoh's played games"
  task :games => [:environment] do
    games = GamerTag.new('saigoh').games

    games.each do |g|
      # Convert the Struct to a hash we can use in Ohm#create
      hash = g.members.zip(g.values).inject({}) { |memo, v| memo[v[0]] = v[1]; memo }

      if Game.find(:title_id => hash[:title_id]).empty?
        puts "New game: #{hash[:name]}"
        Game.create(hash)
      end
    end
  end

  desc "Crawl saigoh's achievements for all games in the system"
  task :achievements => [:environment] do
    Game.all.each do |g|
      puts "#{g.name}"

      achievements = GamerTag.new('saigoh').achievements(g.title_id)
      achievements.each do |achievement|
        # Convert the Struct to a hash we can use in Ohm#create
        hash = achievement.members.zip(achievement.values).inject({}) { |memo, v| memo[v[0]] = v[1]; memo }
        hash[:game] = g

        if ach = Achievement.find(:global_id => Achievement.global_id(g.title_id, hash[:site_id])).first
          puts "    UPDATED -- #{ach.name.ljust(30)} - #{ach.global_id}"
          ach.update(hash)
        else
          ach = Achievement.create(hash)
          puts "    CREATED -- #{ach.name.ljust(30)} - #{ach.global_id}"
          g.achievements << ach
        end
      end

      sleep(2)
    end
  end
end
