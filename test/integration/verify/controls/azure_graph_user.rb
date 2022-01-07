control 'azure_graph_user' do

  user_id = azure_graph_users.object_ids.first
  describe azure_graph_user(user_id: user_id) do
    it                    { should exist }
    its('objectId')       { should eq user_id }
    its('displayName')    { should_not be_nil }
    its('userType')       { should_not be_nil }
    its('accountEnabled') { should_not be_nil }
  end
end
