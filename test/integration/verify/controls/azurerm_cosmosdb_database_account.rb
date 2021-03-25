resource_group = attribute('resource_group', default: "nirbhay-cosmos")
cosmosdb_database_account = attribute('cosmosdb_database_account', default: "nirbhay1997cosmos")

control 'azurerm_cosmosdb_database_account' do
  only_if { !cosmosdb_database_account.nil? }

  describe azurerm_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account) do
    its('id') {should eq "/subscriptions/#{ENV['AZURE_SUBSCRIPTION_ID']}/resourceGroups/nirbhay-cosmos/providers/Microsoft.DocumentDB/databaseAccounts/#{cosmosdb_database_account}"}
    its('name') { should eq cosmosdb_database_account }
    its('location') { should eq 'West US' }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts' }
    its('kind') { should eq 'GlobalDocumentDB' }
    its('properties.provisioningState') { should eq 'Succeeded' }
    its('properties.documentEndpoint') { should eq "https://#{cosmosdb_database_account}.documents.azure.com:443/" }
    its('properties.ipRules') { should eq nil }
    its('properties.isVirtualNetworkFilterEnabled') { should eq false }
    its('properties.virtualNetworkRules') { should eq [] }
    its('properties.databaseAccountOfferType') { should eq "Standard" }
    its('properties.disableKeyBasedMetadataWriteAccess') { should eq false }
    its('properties.consistencyPolicy.defaultConsistencyLevel') { should eq 'Session' }
    its('properties.consistencyPolicy.maxIntervalInSeconds') { should eq 5 }
    its('properties.consistencyPolicy.maxStalenessPrefix') { should eq 100 }

    # its (["properties.writeLocations.id", 1]) { should eq "#{cosmosdb_database_account}-eastus" }
    # its ("properties.writeLocations.locationName") {should eq "East US"}
    # its ("properties.writeLocations.documentEndpoint") {should eq "https://#{cosmosdb_database_account}-eastus.documents.azure.com:443/"}
    # its ("properties.writeLocations.provisioningState") {should eq "Succeeded"}
    # its ("properties.writeLocations.failoverPriority") {should eq 0}
    # its ("properties.readLocations.id") {should eq "#{cosmosdb_database_account}-eastus"}
    # its ("properties.readLocations.locationName") {should eq "East US"}
    # its ("properties.readLocations.documentEndpoint") {should eq "https://#{cosmosdb_database_account}-eastus.documents.azure.com:443/"}
    # its ("properties.readLocations.provisioningState") {should eq "Succeeded"}
    # its ("properties.readLocations.failoverPriority") {should eq 0}
    # its ("properties.locations.id") {should eq "#{cosmosdb_database_account}-eastus"}
    # its ("properties.locations.locationName") {should eq "East US"}
    # its ("properties.locations.documentEndpoint") {should eq "https://#{cosmosdb_database_account}-eastus.documents.azure.com:443/"}
    # its ("properties.locations.provisioningState") {should eq "Succeeded"}
    # its ("properties.locations.failoverPriority") {should eq 0}
    # its ("properties.failoverPolicies.id") {should eq "ddb1-eastus"}
    # its ("properties.failoverPolicies.locationName") {should eq "East US"}
    # its ("properties.failoverPolicies.failoverPriority") {should eq 0}
    # its ("properties.privateEndpointConnections.id") {should eq "/subscriptions/subId/resourceGroups/rg/providers/Microsoft.DocumentDB/databaseAccounts/account1/privateEndpointConnections/pe1"}
    # its ("properties.privateEndpointConnections.properties.privateEndpoint.id") {should eq "/subscriptions/subId/resourceGroups/rg/providers/Microsoft.Network/privateEndpoints/pe1"}
    # its ("properties.privateEndpointConnections.privateLinkServiceConnectionState.status") {should eq "Approved"}
    # its ("properties.privateEndpointConnections.privateLinkServiceConnectionState.actionsRequired") {should eq "None"}
    # cl
    its ("properties.cors") {should eq []}
    its ("properties.enableFreeTier") {should eq true}
    its ("properties.apiProperties") {should eq nil}
    its ("properties.enableAnalyticalStorage") {should eq false}

    its ("properties.locations") {should eq nil}
  end

  describe azurerm_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: 'fake') do
    it { should_not exist }
  end
end