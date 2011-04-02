module CrawlerConfig
  def self.[](key)
    unless @config
      raw_config = File.read(File.expand_path("./../config/crawler.yml", File.dirname(__FILE__)))
      @config = YAML.load(raw_config).symbolize_keys
    end
    @config[key]
  end

  def self.[]=(key, value)
    @config[key.to_sym] = value
  end
end
