#!/bin/bash
#install pre-requisites

sudo yum update && sudo yum upgrade -y
sudo dnf install -y dotnet-runtime-6.0

# configure azagent

prefix="{az_project}-${az_deploymentgroup}\."
vsts_service_file=$(find /etc/systemd/system -type f -name 'vsts.agent*.service' -print -quit)
hostname_in_file=$(sed -n "s/^Description=.*$prefix\([^)]*\).*/\1/p" "$vsts_service_file")
current_hostname=$(hostname)
replace_agent=0

if [ "$hostname_in_file" == "$current_hostname" ]; then
    echo "Hostnames match, replacing agent"
    replace_agent=1
fi

home_dir="/home/ec2-user/"
su - ec2-user <<EOF
if [ -d "$home_dir/azagent" ]; then
    cd $home_dir/azagent
    sudo ./svc.sh stop
    sudo ./svc.sh uninstall

    if [ "$replace_agent" -eq 1 ]; then
        echo "agent has to be replaced"
        echo "removing host $current_hostname from the deployment group"
        ./config.sh remove --unattended \
            --auth PAT \
            --token ${az_token}
    fi

    rm -rf $home_dir/azagent
fi

mkdir -p $home_dir/azagent
cd $home_dir/azagent
curl -fkSL -o vstsagent.tar.gz https://download.agent.dev.azure.com/agent/4.264.2/vsts-agent-linux-x64-4.264.2.tar.gz
tar -zxvf vstsagent.tar.gz
./config.sh --unattended \
    --deploymentgroup \
    --deploymentgroupname ${az_deploymentgroup} \
    --acceptteeeula \
    --agent $HOSTNAME \
    --url https://dev.azure.com/ksolomonm/ \
    --work _work \
    --projectname '${az_project}' \
    --auth PAT \
    --token ${az_token}  \
    --runasservice
sudo ./svc.sh install
sudo ./svc.sh start
EOF