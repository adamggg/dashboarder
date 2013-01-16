module Dashboarder
  module Dashboard
    def self.create!(name, instrument_names)
      instrument_ids = find_instrument_ids instrument_names
      Dashboarder.api.post('/v1/dashboards', { name: name, instruments: instrument_ids })
    end

    def self.compose(name, instrument_names)
      get(name) || create!(name, instrument_names)
    end

    def self.get(name)
      Dashboarder.api.get('/v1/dashboards', :query => {name: name})['dashboards'].first
    end

    def self.update(id, name, instrument_names)
      instrument_ids = find_instrument_ids instrument_names
      Dashboarder.api.put("/v1/dashboards/#{id}", { name: name, instruments: instrument_ids })
    end

    def self.create_or_update!(name, instrument_names)
      if existing_dashboard = get(name)
        update existing_dashboard["id"], name, instrument_names
      else
        create! name, instrument_names
      end
    end

    def self.find_instrument_ids(instrument_names)
      instrument_names.map do |d|
        i = Instrument.get(d) || raise("Instrument #{d} not defined yet")
        i['id']
      end
    end
  end
end
