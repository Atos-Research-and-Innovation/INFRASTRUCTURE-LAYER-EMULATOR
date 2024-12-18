# Developer tools

## Table of Contents (ToC)
<!--ts-->
   * [Developer tools](#Developer-tools)
      * [Shell scripts](#Shell-scripts)
         * [restore_containers_status.sh](#restore_containers_status)
         * [stop_all_running_containers.sh](#stop_all_running_containers)
         * [start_all_running_containers.sh](#start_all_running_containers)
         * [delete_all_running_containers.sh](#delete_all_running_containers)
<!--te-->

The reader could find in this folder different scripts to help managing the emmulation status.

## Shell scripts

### restore_containers_status

Reset emmulation, in case it has been started. The spected input arguments are a total of 3:

- **time_start** *type: (str)*. It represents the time the emulation started. The format is *HH24:MM:SS* and indicates the exact time in which the emulation has started. It must be the same arg. as the one passed in the script **2_exec_fake_time_emulation.sh** described in [back-end](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/back-end)

- **namespace** *type: (str)*. name of the namespace where the service has been deployed in the k3s cluster. It must be the same arg. as the one passed in the script **3_start_service_check.sh** described in [k3s](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/back-end/k3s)

- **service-name** *type: (str)*. Name that the background script will write in the configuration file of the specific container. This name was being served by nodejs service and consumed by the front-end. It must be the same arg. as the one passed in the script **3_start_service_check.sh** described in [k3s](https://github.com/Atos-Research-and-Innovation/INFRASTRUCTURE-LAYER-EMULATOR/tree/main/back-end/k3s)

Usage example:
````bash
sudo ./restore_containers_status.sh "13:50:00" nginx nginx
````

### stop_all_running_containers

Stop all running containers. No arguments are spected to be passed at the input.

Usage example:
````bash
sudo ./stop_all_running_containers.sh
````

### start_all_running_containers

Start all running containers. No arguments are spected to be passed at the input.

Usage example:
````bash
sudo ./start_all_running_containers.sh
````

### delete_all_stopped_containers

Delete all stopped containers (only after stopping every container). No arguments are spected to be passed at the input.

Usage example:
````bash
sudo ./delete_all_stopped_containers.sh
````