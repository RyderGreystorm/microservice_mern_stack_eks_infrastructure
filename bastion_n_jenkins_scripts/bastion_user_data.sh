#!/bin/bash
################################################################################
# Script Name:    bastion_user_data.sh
# Description:    Installs essential tools and services: AWS CLI, kubectl,
#                 Helm, and eksctl.
#
# Author:         Godbless Biekro
# Date Created:   2024-12-14
# Last Modified:  2024-12-14
# Version:        1.1.1
# Notes:          Requires sudo privileges. Tested on Ubuntu 22.04 LTS.
################################################################################

set -e  # Exit immediately if a command exits with a non-zero status.


aws_cli_installation() {
    echo "Installing AWS CLI..."
    sudo apt-get update && sudo apt-get install unzip curl -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
    echo "AWS CLI installed successfully."
}

kubectl_installation() {
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    echo "kubectl installed successfully."
}

helm_installation() {
    echo "Installing Helm..."
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install -y apt-transport-https
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install -y helm
    echo "Helm installed successfully."
}

eksctl_installation() {
    echo "Installing eksctl..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl tar
    curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" -o eksctl.tar.gz
    tar -xzf eksctl.tar.gz
    sudo mv eksctl /usr/local/bin
    eksctl version   
    eksctl completion bash | sudo tee /etc/bash_completion.d/eksctl > /dev/null
    source /etc/bash_completion
}

# Execute installations
aws_cli_installation
kubectl_installation
helm_installation
eksctl_installation
