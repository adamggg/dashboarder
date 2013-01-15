module Dashboarder
  module Instrument
    def self.get(name)
      Dashboarder.api.get('/v1/instruments', :query => {name: name})['instruments'].first
    end

    def self.create!(name, metric_names, source)
      streams = metric_names.map { |n| { metric: n, source: source } }
      Dashboarder.api.post('/v1/instruments', { name: name, streams: streams })
    end

    def self.compose(name, metric_names, source = '*')
      get(name) || create!(name, metric_names, source)
    end
  end
end
