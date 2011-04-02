namespace :fixtures do
  desc "Download fixtures for XBOX Live Resources"
  task :download => [:environment] do
    class Fixture < LiveResource
      def download(url)
        self.class.get(url)
      end
    end

    def download(remote, local)
      local = File.expand_path(File.join(Padrino.root, "spec/fixtures/xbox_live", local))
      puts "#{remote.ljust(50)} -> #{local}"

      response = Fixture.new.download(remote)
      body = response.body.force_encoding("UTF-8")
      File.open(local, 'w') { |f| f.puts(body) }
    end

    download("/GameCenter?compareTo=saigoh",                                 "games_saigoh.html")                   # saigoh's games
    download("/GameCenter/Achievements?titleId=1480657498&compareTo=saigoh", "achievements_saigoh_1480657498.html") # saigoh's achievements on Super Meat Boy
  end
end
