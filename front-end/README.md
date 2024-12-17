# FRONT-END

## Table of Contents (ToC)
<!--ts-->
   * [Set up](#Set-up)
      * [Packages to be installed](#Packages-to-be-installed)
   * [Previously required steps](#Previously-required-steps)
   * [Usage](#Usage)
<!--te-->

## Set up

In this section are listed all the required steps to have the java GUI running.

### Packages to be installed

The emulator has been tested in WSL2

- **java** Version:
`java 21.0.1 2023-10-17 LTS`
`Java(TM) SE Runtime Environment (build 21.0.1+12-LTS-29)`
`Java HotSpot(TM) 64-Bit Server VM (build 21.0.1+12-LTS-29, mixed mode, sharing)`

````bash
sudo apt install openjdk-21-jdk
````

## Previously required steps

Before running the java front-end, the backend based on lxd and the nodejs server must be running. The lxd will be updating the configuration files and the nodejs server will be serving them. There must be also connectivity between nodejs server and the java GUI.

## Usage

Open a new terminal, and in this specific directory execute the following command:

````bash
java java_gui.java
````