class CreateAirPollutionDataPoint < ActiveRecord::Migration[7.0]
  def change
    create_table :air_pollution_data_points do |t|
      t.integer :aqi, index: true
      t.references :location, index: true
      t.datetime :received_at, index: true
      t.jsonb :components, default: {}

      t.timestamps
    end
  end
end
