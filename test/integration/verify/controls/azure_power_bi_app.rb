app_id = input(:app_id, value: '')

control 'Verify the settings of a Power BI App' do

  impact 1.0
  title 'Testing the singular resource of azure_power_bi_app.'
  desc 'Testing the singular resource of azure_power_bi_app.'

  describe azure_power_bi_app(app_id: app_id) do
    it { should exist }
  end
end
