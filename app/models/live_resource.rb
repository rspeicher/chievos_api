class LiveResource
  include HTTParty

  base_uri 'live.xbox.com'

  cookies({
    'PersistentId' => CrawlerConfig[:persistent_id],
    'RPSAuth'      => CrawlerConfig[:rps_auth]
  })
end
