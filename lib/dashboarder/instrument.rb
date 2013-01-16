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

    def self.update(id, name, metric_names, source)
      streams = metric_names.map { |n| { metric: n, source: source } }
      Dashboarder.api.put("/v1/instruments/#{id}", { name: name, streams: streams })
    end

    def self.create_or_update!(name, metric_names, source)
      if existing_instrument = get(name)
        update existing_instrument["id"], name, metric_names, source
      else
        create! name, metric_names, source
      end
    end
  end
end
