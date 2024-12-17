# K3S

## Table of Contents (ToC)
<!--ts-->
   * [Environment Set Up](#Environment-Set-Up)
      * [LXD profile](#LXD-profile)
   * [Cluster deployment](#Cluster-deployment)
<!--te-->

In this readme you will find the steps needed to deploy a k3s cluster over the containers previously created over LXD.

## Environment preparation

### LXD profile

Additionally, create the profile for the container in order to execute them in privileged mode.

**Steps**

**1 -** For this we shoud create a profile taking the default profile as a baseline:

````bash
sudo lxc profile copy default k3s-profile
````

**2 -** Modify it to add the desired fields:

````bash
sudo lxc profile edit k3s-profile
````

**3 -** It will open a the config file in the nano text editor and here we add the corresponding key value pairs under the config field. The result should be something similar to this:

``` yaml
name: k3s-profile
description: Default LXD profile
config:
  linux.kernel_modules: ip_tables,ip6_tables,nf_nat,overlay
  raw.lxc: |-
    lxc.cap.drop=
    lxc.cgroup.devices.allow=a
    lxc.mount.auto=proc:rw sys:rw
    lxc.sysctl.vm.overcommit_memory=1
    lxc.sysctl.kernel.panic=10
    lxc.sysctl.kernel.panic_on_oops=1
  security.nesting: "true"
  security.privileged: "true"
devices:
  eth0:
    name: eth0
    network: lxdbr0
    type: nic
  root:
    path: /
    pool: default
    type: disk
used_by: []
```

### LXD connectivity

In case there exist problems with the connectivity regarding the firewall or docker conflicts, please check the following [link](https://documentation.ubuntu.com/lxd/en/latest/howto/network_bridge_firewalld/).

## Cluster deployment

After completing the environment preparation steps, go back to the readme in the [back-end](https://github.gsissc.myatos.net/GLB-BDS-ETSN-SNS/DECENTRALIZED-CONTINUUM-ORCHESTRATION/tree/develop/ILE/LXD_Container_Approach/back-end) directory an follow the steps to deploy the desired LXD containers that will compose the whole emulation. Once the nodes are properly deployed, go to the following steps that will let the reader to deploy several fully functional k3s clusters on the top of the previously deployed LXD containers.

**1 -** Deploy k3s master nodes:

````bash
sudo ./1_create_masters.sh <master-node1> <master-node2> [...] <master-nodeN>
````

After waiting a bit for the master node to be deployed, the following commands could be executed to copy the kubeconfig into `~/.kube/config` (assuming kubectl is installed in the host machine) and be able to access the cluster from the host through the kubernetes API.

````bash
cnt_name="<master-node>"
cnt_ip="<ContainerIP (eth0)>"
# Create directory ~/.kube/ILE/ if it does not exist.
mkdir -p ~/.kube/ILE
# Get the config file and store it in ~/.kube/ILE/
sudo lxc exec $cnt_name -- sh -c "k3s kubectl config view --flatten" > ~/.kube/ILE/LXD_k3s_${cnt_name}_config.yaml
# Change the IP from localhost to the container eth0 IP
sed -i "s/127.0.0.1/${cnt_ip}/g" ~/.kube/ILE/LXD_k3s_${cnt_name}_config.yaml
# Overwrite the ~/.kube/config file
cp ~/.kube/ILE/LXD_k3s_${cnt_name}_config.yaml ~/.kube/config
````

**2 -** Create worker nodes and attach them to the master.

````bash
sudo ./2_create_agent_nodes.sh <master-node> <worker-node1> <worker-node2> [...] <worker-nodeN>
````

**3 -** Execute service checking scripts in case certain service has been deployed over the k3s cluster.

````bash
sudo ./3_start_service_check.sh <namespace> <service-name>
````

Now you can go back to the [back-end](https://github.gsissc.myatos.net/GLB-BDS-ETSN-SNS/DECENTRALIZED-CONTINUUM-ORCHESTRATION/tree/develop/ILE/LXD_Container_Approach/back-end) readme to finish the emulation.