control 'azure_graph_generic_resource' do
  only_if { ENV['GRAPH'] }

  user_id = azure_graph_users.user_principal_names.sample
  describe azure_graph_generic_resource(resource: 'users', id: user_id) do
    it { should exist }
    its('userPrincipalName') { should eq user_id }
  end
end
