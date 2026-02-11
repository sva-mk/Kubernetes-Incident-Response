#!/bin/bash
# The registry has to be created first.
  workspace_list=("registry" "rancher" "openshift" "k3s" "kubernetes")

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

create_workspaces() {

  for name in "${workspace_list[@]}"; do
    if terraform workspace select $name 2>/dev/null; then
      echo "Workspace '$name' already exists. Skipping..."
    else
      terraform workspace new $name
      echo "Workspace '$name' created successfully."
    fi
  done

}

# Prepare Workspaces
if [ "$(terraform workspace list | tr -d '*' | wc -w)" -le 1 ]; then
  create_workspaces
fi

# Main-Loop
for workspace in "${workspace_list[@]}"; do
  if [ "$workspace" != "default" ]; then
    if terraform workspace select $workspace 2>/dev/null; then
      apply_with_retry $workspace
    else
      echo "Workspace '$workspace' does not exist. Skipping..."
    fi
  fi
done

# Check-Loop
for workspace in "${workspace_list[@]}"; do
  if [ "$workspace" != "default" ] && [ "$workspace" != "registry" ]; then
    if terraform workspace select $workspace 2>/dev/null; then
      export KUBECONFIG=../kubeconfigs/$(terraform workspace show)/kubeconfig
      kubectl get nodes -o=wide
    else
      echo "Workspace '$workspace' does not exist. Skipping..."
    fi
  fi
done
