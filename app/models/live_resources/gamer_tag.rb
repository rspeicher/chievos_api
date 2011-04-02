class GamerTag < LiveResource
  # @see {achievements}
  class Achievement < Struct.new(:site_id, :name, :secret, :value, :tile_path); end

  # @see {games}
  class Game < Struct.new(:name, :guid, :title_id); end

  def initialize(tag)
    @tag = tag
  end

  # Returns an array of this {GamerTag}'s games
  #
  # Each array entry is a {GamerTag::Game} instance, which is a
  # <tt>Struct</tt> with the following attributes:
  # * <tt>name</tt>
  # * <tt>guid</tt>
  # * <tt>title_id</tt>
  #
  # @return [Array]
  def games
    doc = Nokogiri::HTML(fetch_games)

    games = []

    doc.css('div.LineItem').each do |div|
      game = Game.new

      # Extract name from h3
      game.name = div.css('div.TitleInfo h3').first.text.strip

      # Extract guid from game link
      game.guid = div.css('div.TitleInfo a').first['href'].gsub(/.*\/([^\/]+)$/, '\1')

      # Extract title_id from "Compare Achievements" link
      game.title_id = div.css('div.lastgridchild a').first['href'].gsub(/.*titleId=(\d+).*/, '\1')

      games << game
    end

    games
  end

  # Returns an array of <tt>GamerTag::Achievements</tt> for a specific game.
  #
  # Each array entry is a {GamerTag::Achievement} instance, which is a
  # <tt>Struct</tt> with the following attributes:
  # * <tt>site_id</tt>
  # * <tt>name</tt>
  # * <tt>secret</tt>
  # * <tt>value</tt>
  # * <tt>tile_path</tt>
  #
  # @param [String] title_id The game's title_id attribute
  # @return [Array]
  def achievements(title_id)
    doc = Nokogiri::HTML(fetch_achievements(title_id))

    achievements = []

    doc.css('div.SpaceItem').each do |div|
      ach = Achievement.new

      # Extract site_id from div ID
      ach.site_id = div.css('div.AchievementInfo').first['id'].gsub(/^ach-(\d+)$/, '\1')

      # Extract name from h3
      ach.name = div.css('div.AchievementInfo h3').first.text.strip

      # Determine secret from title
      ach.secret = ach.name == "Secret Achievement"

      # Extract value from GamerScore div
      ach.value = div.css('div.GamerScore').first.text.strip

      # Extract tile_path from image
      if ach.secret
        ach.tile_path = ""
      else
        ach.tile_path = div.css('img.AchievementIcon').first['src'].gsub(/.*tiles\/(.+)\.(jpg|png)$/, '\1')
      end

      achievements << ach
    end

    achievements
  end

  private

  # Fetches the response body for this tag's played games page
  def fetch_games
    response = self.class.get('/en-US/GameCenter', :query => {:compareTo => @tag})

    response.body
  end

  # Fetches the response body for this tag's achievements for a specific game
  def fetch_achievements(title_id)
    response = self.class.get('/en-US/GameCenter/Achievements', :query => {:titleId => title_id, :compareTo => @tag})

    response.body
  end
end
