#!/bin/bash

# Install dependencies
apt-get update && apt-get install apt-transport-https curl --yes

# Add Microsoft Apt Repo
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

# Get the Microsoft signing key
curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Install CLI
apt-get update && apt-get install azure-cli
