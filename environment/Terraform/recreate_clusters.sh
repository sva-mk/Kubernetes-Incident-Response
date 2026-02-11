#!/bin/bash

workspaces=$(terraform workspace list | tr -d '*')

apply_with_retry() {
  local max_retries=5
  local attempt=1

  while [ $attempt -le $max_retries ]; do
    terraform apply -var-file $1.tfvars -auto-approve

    if [ $? -eq 0 ]; then
      echo "Apply for '$1' successful."
      break
    else
      echo "Apply for '$1' failed (Attempt $attempt). Retrying..."
      ((attempt++))
    fi
  done
}

# Delete clusters (except registry)
for workspace in $workspaces; do
  if [ "$workspace" != "default" ] && [ "$workspace" != "registry" ]; then
    if terraform workspace select $workspace 2>/dev/null; then
      echo "Workspace '$workspace' exists. Deleting..."
      terraform destroy -var-file $workspace.tfvars -auto-approve
    fi
  fi
done

# Main-Loop
for workspace in $workspaces ; do
  if [ "$workspace" != "default" ]; then
    if terraform workspace select $workspace 2>/dev/null; then
      apply_with_retry $workspace
    else
      echo "Workspace '$workspace' does not exist. Skipping..."
    fi
  fi
done

# Check-Loop
for workspace in  $workspaces; do
  if [ "$workspace" != "default" ] && [ "$workspace" != "registry" ]; then
    if terraform workspace select $workspace 2>/dev/null; then
      export KUBECONFIG=../kubeconfigs/$(terraform workspace show)/kubeconfig
      kubectl get nodes -o=wide
    else
      echo "Workspace '$workspace' does not exist. Skipping..."
    fi
  fi
done