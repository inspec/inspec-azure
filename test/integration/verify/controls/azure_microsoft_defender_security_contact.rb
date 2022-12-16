control "azure_microsoft_defender_security_contact" do
  title "Testing the singular resource of azure_microsoft_defender_security_contact."
  desc "Testing the singular resource of azure_microsoft_defender_security_contact."

  describe azure_microsoft_defender_security_contact(name: "default") do
    it { should exist }
  end

  describe azure_microsoft_defender_security_contact(name: "default") do
    its("id") { should_not be_empty }
    its("name") { should eq "default" }
    its("type") { should eq "Microsoft.Security/securityContacts" }
    its("etag") { should_not be_empty }
    its("location") { should eq "West Europe" }
  end

  describe azure_microsoft_defender_security_contact(name: "default") do
    its("properties.notificationsByRole.state") { should eq "On" }
    its("properties.notificationsByRole.roles") { should include "Owner" }

    its("properties.emails") { should be_empty }
    its("properties.phone") { should be_empty }
    its("properties.alertNotifications.state") { should include "Off" }
    its("properties.alertNotifications.minimalSeverity") { should include "High" }
  end
end
