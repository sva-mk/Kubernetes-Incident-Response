#!/bin/bash

workspaces=$(terraform workspace list | tr -d '*')

# Delete clusters
for workspace in $workspaces; do
  if [ "$workspace" != "default" ]; then
    if terraform workspace select $workspace 2>/dev/null; then
      echo "Workspace '$workspace' exists. Deleting..."
      terraform destroy -var-file $workspace.tfvars -auto-approve
    fi
  fi
done

# Delete workspaces
workspaces=$(terraform workspace list | tr -d '*')
terraform workspace select default

for workspace in $workspaces; do
  if [ "$workspace" != "default" ]; then
    terraform workspace delete $workspace
    echo "Workspace '$workspace' deleted successfully."
  fi
done
