control 'azure_graph_users' do

  describe azure_graph_users do
    its('display_names')       { should_not be_empty }
    its('user_types')          { should_not be_empty }
    its('mails')               { should_not be_empty }
  end
end
