app_id = input(:app_id, value: '')
control 'Verify the settings of a Power BI App' do
  describe azure_power_bi_app(app_id: app_id) do
    it { should exist }
  end
end
