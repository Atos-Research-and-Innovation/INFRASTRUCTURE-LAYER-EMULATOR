# BACK-END

## Table of Contents (ToC)
<!--ts-->
- [BACK-END](#back-end)
  - [Table of Contents (ToC)](#table-of-contents-toc)
- [Overview](#overview)
- [Environment Set Up](#environment-set-up)
  - [Packages to be installed](#packages-to-be-installed)
    - [LXD](#lxd)
    - [NodeJS](#nodejs)
    - [Kubectl](#kubectl)
    - [Helm](#helm)
  - [Custom Images](#custom-images)
- [Emulation examples](#emulation-examples)
  - [Lightweight emulation](#lightweight-emulation)
    - [Lightweight introduction](#lightweight-introduction)
    - [Lightweight deployment steps](#lightweight-deployment-steps)
  - [K3s emulation](#k3s-emulation)
    - [K3s introduction](#k3s-introduction)
    - [K3s deployment steps](#k3s-deployment-steps)
  - [Video streaming emulation](#video-streaming-emulation)
    - [Video streaming introduction](#video-streaming-introduction)
    - [Video streaming deployment steps](#video-streaming-deployment-steps)
  - [Custom emulation](#custom-emulation)
    - [Custom emulation introduction](#custom-emulation-introduction)
    - [Custom emulation deployment steps](#custom-emulation-deployment-steps)
<!--te-->

# Overview

In this section are listed all the required steps to have the **Infrastructure Layer Emulator (ILE)** running over LXD.

First of all, there are some common steps to be executed in order to have the environment ready for deploying the back end. To complete them, follow the steps in the section [Environment Set Up](#environment-set-up).

For deeper information about the shell scripts used in this project [Shell scripts](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts) contains a brief description of the purpose of each shell script and the corresponding usage, showing what are the arguments that must be passed at the input.

Additionally, a couple of predefined examples are already created in this repository and are ready to use, its usage is explained in the corresponding sections [Lightweight emulation](#lightweight-emulation) and [K3s emulation](#k3s-emulation).

After checking the usage of the scripts and, therefore, the emulation examples, the user can customize its own emulation by creating a new file with the format: **1_create_emulation_<emulation_name>.sh** and making the corresponding calls to **create_containers.sh** with the appropiate input arguments depending on the specific use case.

# Environment Set Up

## Packages to be installed

Note: The emulator has been tested in WSL2

### LXD

Installed through snap. Version: `5.21.1 LTS`

**Steps:**

**1 -** Execute the following command to install **lxd**

````bash
sudo snap install lxd --channel=5.21/stable
````

Or, in case it's already installed, update it to 5.21 version:

````bash
sudo snap refresh lxd --channel=5.21/stable
````

**2 -** Initialize it with the default configuration. For this, execute the following command:

````bash
sudo lxd init
````

After that, some options will be prompted. The user must indicate as shown in the following image:

![IRS_Image](../../../docs/lxd_init.png)

### NodeJS

Installed through apt-get. Version: `v12.22.9`

**Steps:**

**1 -** Execute the following command:

````bash
sudo apt-get install nodejs
````

### Kubectl

Installed downloading the binary. Version: `v1.29.3`

**Steps:**

**1 -** Download the binary:

````bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.29.3/bin/linux/amd64/kubectl
````

**2 -** Make it executable:

````bash
chmod +x ./kubectl
````

**3 -** Move it to PATH:

````bash
sudo mv ./kubectl /usr/local/bin/kubectl
````

### Helm

Installed through snap. Version: `3.15.3`

**Steps:**

**1 -** Execute the following command to install **helm**

````bash
sudo snap install helm --channel=3.15.3/stable
````

<!-- ## SSH Keys

As the script will enter in each container through ssh and we are using public key authentication.

**Steps:**

**1 -** Generate the key pair (public and private key). Execute the following command and accept all default prompted options:

````bash
ssh-keygen
````

**2 -** Create a folder `ssh-keypair` in the same directory of this readme file:

````bash
mkdir ssh-keypair
````

**3 -** Copy the public and private key (`id_rsa.pub` and `id_rsa` repectively) into the creted folder `ssh-keypair`:

````bash
cp ~/.ssh/id_rsa.pub ssh-keypair/id_rsa.pub
cp ~/.ssh/id_rsa ssh-keypair/id_rsa
````

P.S: The private and public key are stored by default at: `~/.ssh`

**4 -** Copy the file from `~/.ssh/id_rsa` to `/root/.ssh/id_rsa` in the host machine (you must be root to copy the file):

Note: If you have executed the **step 2** as root, you can ommit this step, as the source and destination files to be copied will be the same you will receive the following error:
`cp: 'id_rsa' and 'id_rsa' are the same file`

````bash
cp ~/.ssh/id_rsa /root/.ssh/id_rsa
```` -->

## Custom Images

<!-- Note: You **must** execute the previous [SSH Keys](#SSH-Keys) steps before. -->

<!-- **IMPORTANT INFORMATION:** The default repository for LXD *https://images.linuxcontainers.org* is not available anymore. More information in the following link: *https://discuss.linuxcontainers.org/t/lxc-image-list-images-output-is-empty/18978/3*. There will be only available ubuntu and ubuntu-minimal images through the official ubuntu images server *https://cloud-images.ubuntu.com/releases*.  -->

The following commands will create the custom images in lxd necessary to exeute the emulation examples:

**Steps:**

**1 -** Execute the following commands to create the custom images:

````bash
sudo images_management/create_custom_alpine.sh
sudo images_management/create_custom_ubuntu.sh
````

Them are ubuntu and alpine images but with some necesary linux packages preinstalled.

# Emulation examples

There are two emulation examples already prepared in this repository for testing purposes. Just read the introduction of each of them and choose one. Then, follow the corresponding usage section in order to deploy the emulation.

## Lightweight emulation

### Lightweight introduction

The first one is for having 3 stakeholders represented with several extreme edge nodes deployed. That's what we called the **"lightweight"** emulation as the containers rely on alpine, which is a minimalistic linux distribution in order to minimize the resource constumption of each container, and hence, of the whole emulation itself. This emulation is valid mainly for **visualization and testing** purposes, but no cluster and obviously no service is intended to be deployed on the top of the nodes that compose the whole emulation. The main goal is to show how the containers belonging to the extreme edge turn off and on continuously based on a predefined configuration showcasing the high volvaility of the extreme edge nodes within future 6G networks.

### Lightweight deployment steps

Note: It's assumed that every command must be executed in the directory where this readme file is located.

**1 -** Open a linux terminal on the host and execute the following command:

````bash
sudo ./1_create_emulation_lightweight.sh alpine
````

This will create all the containers, one per line in the executed script.
<!---
Inside the extreme edge containers the corresponding files for managing the turnning on and off are created under the directory /usr/share/ils/bin
-->

**2 -** Execute the following command in the same terminal to start the emulation. Be aware that the **<time_start>** argument depends on the current hour, so it must be set before executing the command. For more information about the input arguments refer to [2_execute_emulation.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#2_execute_emulation):

````bash
sudo ./2_execute_emulation.sh <time_start>
````

**3 -** Execute the final command in the same terminal, to continuously monitor the containers. Be aware that the **<time_start>** argument depends on the current hour, so it must be set before executing the command. For more information about the input arguments refer to [3_get_containers_status.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#3_get_containers_status):

````bash
sudo ./3_get_containers_status.sh nodejs-server/config_matrix.txt nodejs-server/matrix_size.txt nodejs-server/time_diff.txt <time_start> 3600
````

**4 -** Open a new terminal and execute the following command:

````bash
nodejs nodejs-server/file-server-express.js
````

This will serve the files needed through port 8080. Once arrived to this point everything is set up and running for the back-end, Refer to [front-end](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/front-end)

## K3s emulation

### K3s introduction

The second one is what we called **"K3s"** emulation. In this one the containers rely on ubuntu linux distribution which allows us to build a more functional emulation example. In that case we are going to deploy on the top of the containers a k3s cluster that will let the user to deploy **network services** based on uservices. There is additional logic that let the system realize when a node has been turned off or on. Consequently, k3s will deploy a new uservice instance in another node that is available in that specific instant.

### K3s deployment steps

Note: It's assumed that every command must be executed in the directory where this readme file is located.

Initial step - Before going into the steps for this emulation, go to the [K3s](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/back-end/k3s) readme and complete the section called **Environment preparation**

**1 -** Execute the following command to create the containers:

````bash
sudo ./1_create_emulation_k3s.sh ubuntu
````

**2 -** Once the containers are deployed, go to `k3s` directory in order to start deploying the k3s cluster that will have 1 master node and 15 worker nodes. So, execute the following command in the same terminal to change the directory:

````bash
cd k3s
````

**3 -** Once located in the corresponding directory, create the master node in the container called ubuntu-24-9. The k3s node will have the same name:

````bash
sudo ./1_create_masters.sh ubuntu-24-9
````

**4 -** Execute the following command in order to get the IPv4 eth0 of the container where the master node is deployed. Copy and keep it as it will be useful to access the cluster from the host using kubectl.

````bash
sudo lxc list
````

**5 -** Execute the following commands to get the kubeconfig from the master node (ubuntu-24-9) and copy it in `~/.kube/config` to be able to access the k3s cluster through the API. Keep in mind that the last command will overwritte the `~/.kube/config`, so you will lose the current content of the file if any.

````bash
cnt_name="ubuntu-24-9"
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

**6 -** Now, attach the corresponding worker nodes to the master by executing the following command in the same terminal:

````bash
sudo ./2_create_agent_nodes.sh ubuntu-24-9 <master-IP> ubuntu-19-3 ubuntu-19-11 ubuntu-20-2 ubuntu-20-11 ubuntu-21-5 ubuntu-21-9 ubuntu-21-11 ubuntu-21-15 ubuntu-21-17 ubuntu-22-7 ubuntu-22-12 ubuntu-22-15 ubuntu-25-3 ubuntu-25-8 ubuntu-25-9
````

**7 -** Deploy test nginx service. There is a dummy service under the directory called `services` (assuming that you are located at `k3s` directory) wich is a nginx app that will create 4 different replicas of the same pod into 4 different nodes. Three of them will be deployed at core/edge nodes (wich are assumed to NOT be volatile) and another one in a node located in a extreme edge node.

````bash
kubectl apply -f services/nginx_dummy.yaml
````

**8 -** In case LXD it's being used in WSL the port must be exposed through a proxy in order to be accessible from Windows.

````bash
sudo lxc config device add ubuntu-24-9 myproxy30788 proxy listen=tcp:0.0.0.0:30788 connect=tcp:127.0.0.1:30788 bind=host
````

Now it will be accessible through **localhost:30788**

Another option is to install a navigator inside WSL (for example firefox) and open it from the WSL terminal:

````bash
sudo apt-get install firefox
firefox
````

Within this navigator the exposed service could be accessed from the typing the container IP address in which the master is deployed and the service nodeport: **<ContainerIP (eth0)>:30788**

**9 -** Execute the following command to monitor in which nodes the service is deployed:

````bash
sudo ./3_start_service_check.sh nginx nginx
````

**10 -** Once you have finished the stps here, the cluster is deployed over the containers, and the dummy service over the k3s cluster, come back to the back-end directory: 

````bash
cd ..
````

**11 -** Here, execute the following command to start the emulation. Be aware that the **<time_start>** argument depends on the current hour, so it must be set before executing the command. For more information about the input arguments refer to [2_execute_emulation.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#2_execute_emulation):

````bash
sudo ./2_execute_emulation.sh <time_start>
````

**12 -** Execute the final command in the same terminal, to continuously monitor the containers. Be aware that the **<time_start>** argument depends on the current hour, so it must be set before executing the command. For more information about the input arguments refer to [3_get_containers_status.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#3_get_containers_status):

````bash
sudo ./3_get_containers_status.sh nodejs-server/config_matrix.txt nodejs-server/matrix_size.txt nodejs-server/time_diff.txt <time_start> 60
````

Note: The main goal of this emulation is to showcase how a replica of a certain service deployed in k3s is disappearing and appearing again when a certain k3s node is removed and reattached from the cluster. So, to give time to k3s to realize the node has disappeared and take actions, i.e. deploy another replica of the service, it's highly recommended to use the argument `time_factor=60` here to avoid the containers to be continuously changing from on to off and viceversa.
The same applies when configuring the **time_pattern** argument for the script [create_containers.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#create_containers) inside [1_create_emulation_k3s.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#1_create_emulation_k3s) for each container, it's recommended to leave at least 2 hours (that will be minutes due to the time_factor definition to 60) between the turn on and off.

To summ up, without changing [1_create_emulation_k3s.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#1_create_emulation_k3s) file and using arg. `time_start=60` in step 3 at [Lightweight deployment steps](#Lightweight-deployment-steps) is sufficient to see how the replica of the service is changing over the containers, as some of the containers that are in state on will change to off every 2 minutes and viceversa.

However this is important to have in mind then creating a custom emulation file with the format **1_create_emulation_<emulation_name>.sh**.

**13 -** Open a new terminal and execute the following command:

```bash
nodejs nodejs-server/file-server-express.js
```

This will serve the files needed through port 8080. Once arrived to this point everything is set up and running for the back-end, Refer to [front-end](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/front-end)

## Video streaming emulation

### Video streaming introduction

The second one is what we called **"K3s"** emulation. In this one the containers rely on ubuntu linux distribution which allows us to build a more functional emulation example. In that case we are going to deploy on the top of the containers a k3s cluster that will let the user to deploy **network services** based on uservices. There is additional logic that let the system realize when a node has been turned off or on. Consequently, k3s will deploy a new uservice instance in another node that is available in that specific instant.

### Video streaming deployment steps

Note: It's assumed that every command must be executed in the directory where this readme file is located.

Initial step - Before going into the steps for this emulation, go to the [K3s](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/back-end/k3s) readme and complete the section called **Environment preparation**

**1 -** Execute the following command to create the containers:

````bash
sudo ./1_create_emulation_video_streaming.sh
````

**2 -** Once the containers are deployed, go to `k3s` directory in order to start deploying the k3s cluster that will have 1 master node and 15 worker nodes. So, execute the following command in the same terminal to change the directory:

````bash
cd k3s
````

**3 -** Once located in the corresponding directory, create the master node in the container called ubuntu-24-9. The k3s node will have the same name:

````bash
sudo ./1_create_masters.sh ubuntu-10-11
````

**4 -** Execute the following command in order to get the IPv4 eth0 of the container where the master node is deployed. Copy and keep it as it will be useful to access the cluster from the host using kubectl.

````bash
sudo lxc list
````

**5 -** Execute the following commands to get the kubeconfig from the master node (ubuntu-24-9) and copy it in `~/.kube/config` to be able to access the k3s cluster through the API. Keep in mind that the last command will overwritte the `~/.kube/config`, so you will lose the current content of the file if any.

````bash
cnt_name="ubuntu-10-11"
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

**Note:** For checking purposes, execute the command `kubectl get nodes`. If the result obtained is a master node with the name **ubuntu-10-11** it's working properly until here.

**6 -** Now, attach the corresponding worker nodes to the master by executing the following command in the same terminal:

````bash
sudo ./2_create_agent_nodes.sh ubuntu-10-11 "<ContainerIP (eth0)>" ubuntu-6-9 ubuntu-6-11 ubuntu-8-7 ubuntu-8-15 ubuntu-11-8 ubuntu-11-10 ubuntu-11-11 ubuntu-11-14 ubuntu-12-5 ubuntu-13-15 ubuntu-14-8 ubuntu-15-10
````

**Note:** For checking purposes, execute the command `kubectl get nodes`. If the result obtained is a master node with other 12 workers attached, it's working properly until here.

The service is defined in such a way that cannot be two replicas of the deployment **receiver-encoder-publisher** deployed in the same node.

**7 -** Deploy 6g latency sensitive service workflow 2, (frontend + receiver + mediamtx).

````bash
cd services/6g-latency-sensitive-service/chart
````

**8 -** Execute the following command to deploy the service and answer "no" to the prompt message to indicate that no robor arm is present.

````bash
./apply-k8s-config.sh
````

**9 -** Check the master node internal IP address and keep it for the next step by executing the following command:

````bash
kubectl get nodes -o wide
````

**10 -** Come back to 6g-latency-sensitive-service directory.

````bash
cd ..
````

**11 -** In another terminal, execute the following command to send the streaming data from the built-in cammera to the front end uservice. The IP of the load balancer should be checked before:

````bash
python3 sender.py <Master-Node-IP> 5555 -d /dev/video0 -w 1280 -H 720 -f 30
````

**12 -** Come back to k3s directory.

````bash
cd ../../..
````

**13 -** Install a navigator inside WSL (for example firefox) and open it from the WSL terminal:

````bash
sudo apt-get install firefox
firefox
````

Within this navigator, the exposed service front-end could be accessed typing the master node IP address already retrieved in step 9, and the LoadBalancer port: **&lt;Master-Node-IP&gt;:5000/streaming**

**14 -** Execute the following command to monitor in which nodes the service is deployed:

````bash
sudo ./3_start_service_check.sh ilens ilens
````

**15 -** Once you have finished the stps here, the cluster is deployed over the containers, and the dummy service over the k3s cluster, come back to the back-end directory: 

````bash
cd ..
````

**16 -** Here, execute the following command to start the emulation. Be aware that the **<time_start>** argument depends on the current hour, so it must be set before executing the command. For more information about the input arguments refer to [2_execute_emulation.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#2_execute_emulation):

````bash
sudo ./2_execute_emulation.sh <time_start>
````

**17 -** Execute the final command in the same terminal, to continuously monitor the containers. Be aware that the **<time_start>** argument depends on the current hour, so it must be set before executing the command. For more information about the input arguments refer to [3_get_containers_status.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#3_get_containers_status):

````bash
sudo ./3_get_containers_status.sh nodejs-server/config_matrix.txt nodejs-server/matrix_size.txt nodejs-server/time_diff.txt <time_start> 60
````

Note: The main goal of this emulation is to showcase how a replica of a certain service deployed in k3s is disappearing and appearing again when a certain k3s node is removed and reattached from the cluster. So, to give time to k3s to realize the node has disappeared and take actions, i.e. deploy another replica of the service, it's highly recommended to use the argument `time_factor=60` here to avoid the containers to be continuously changing from on to off and viceversa.
The same applies when configuring the **time_pattern** argument for the script [create_containers.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#create_containers) inside [1_create_emulation_k3s.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#1_create_emulation_k3s) for each container, it's recommended to leave at least 2 hours (that will be minutes due to the time_factor definition to 60) between the turn on and off.

To summ up, without changing [1_create_emulation_k3s.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#1_create_emulation_k3s) file and using arg. `time_start=60` in step 3 at [Lightweight deployment steps](#Lightweight-deployment-steps) is sufficient to see how the replica of the service is changing over the containers, as some of the containers that are in state on will change to off every 2 minutes and viceversa.

However this is important to have in mind then creating a custom emulation file with the format **1_create_emulation_<emulation_name>.sh**.

**18 -** Open a new terminal and execute the following command:

```bash
nodejs nodejs-server/file-server-express.js
```

This will serve the files needed through port 8080. Once arrived to this point everything is set up and running for the back-end, Refer to [front-end](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/front-end)

## Custom emulation

### Custom emulation introduction

Before starting to create your own custom emulation, it's highly recommended to go through both emulation examples prepared in this readme in order to understand better how all the scripts work and what are the modifiable arguments for them. You can find these examples in the sections [Lightweight emulation](#lightweight-emulation) and [K3s emulation](#k3s-emulation).

### Custom emulation deployment steps

**1 -** Create your own script with the format **1_create_emulation_<emulation_name>.sh**, you can take [1_create_emulation_lightweight.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts#1_create_emulation_lightweight) and [1_create_emulation_k3.sh](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/wiki/Scripts1_create_emulation_k3) as examples.

**2 -** Execute the newly created script to create all the containers with the specific time configurations for the emulation:

````bash
sudo ./1_create_emulation_<emulation_name>.sh <cnt_name_suffix>
````

**3 -** In case is desired to deploy a cluster with one master and some number of worker nodes, follow the steps at [K3s](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/back-end/k3s).

**4 -** Once the cluster is up and running, execute the following comman:

````bash
sudo ./2_execute_emulation.sh <time_start>
````

**5 -** Execute the final command in the same terminal, to continuously monitor the containers:

````bash
sudo ./3_get_containers_status.sh <config_matrix> <config_size> <time_diff> <time_start> <time_factor>
````

**6 -** Open a new terminal and execute the following command:

````bash
nodejs nodejs-server/file-server-express.js
````

This will serve the files needed through port 8080. Once arrived to this point everything is set up and running for the back-end, Refer to [front-end](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/front-end)