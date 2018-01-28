---
title: Kubernetes Master From Scratch
author: gkudra-msft
ms.author: gekudray
ms.date: 11/16/2017
ms.topic: get-started-article
ms.prod: containers

description: Creating a Kubernetes cluster master from scratch.
keywords: kubernetes, 1.9, master, linux
---

# Kubernetes Master  From Scratch #
This page will walk through a manual deployment of a Kubernetes master from start to finish.

A recently-updated, Ubuntu-like Linux machine is required to follow along. Windows does not come into the picture at all; binaries are cross-compiled from Linux.


> [!Warning]  
> Because of the volatility of Kubernetes from version to version, this guide may make assumptions that are not true in the future.


## Preparing the Master ##
First, install all of the pre-requisites:

```bash
sudo apt-get install curl git build-essential docker.io conntrack python2.7
```

If you are behind a proxy, define environment variables for the current session:
```bash
HTTP_PROXY=http://proxy.example.com:80/
HTTPS_PROXY=http://proxy.example.com:443/
http_proxy=http://proxy.example.com:80/
https_proxy=http://proxy.example.com:443/
```
Or if you would like to make this setting permanent, add the variables to /etc/environment (logging out and back in is required in order to apply changes).

There is a collection of scripts in [this repository](https://github.com/Microsoft/SDN/tree/master/Kubernetes/linux), which help with the setup process. Check them out to `~/kube/`; this entire directory will be getting mounted for a lot of the Docker containers in future steps, so keep its structure the same as outlined in the guide.

```bash
mkdir ~/kube
mkdir ~/kube/bin
git clone https://github.com/Microsoft/SDN /tmp/k8s 
cd /tmp/k8s/Kubernetes/linux
chmod -R +x *.sh
chmod +x manifest/generate.py
mv * ~/kube/
```


### Installing the Linux Binaries ###

> [!Note]  
> To include patches or use bleeding-edge Kubernetes code instead of downloading pre-built binaries, see [this page](./compiling-kubernetes-binaries.md).

Download and install the official Linux binaries from the [Kubernetes mainline](https://github.com/kubernetes/kubernetes/releases/tag/v1.9.1) and install them like so:

```bash
wget -O kubernetes.tar.gz https://github.com/kubernetes/kubernetes/releases/download/v1.9.1/kubernetes.tar.gz
tar -vxzf kubernetes.tar.gz 
cd kubernetes/cluster 
# follow the prompts from this command, the defaults are generally fine:
./get-kube-binaries.sh
cd ../server
tar -vxzf kubernetes-server-linux-amd64.tar.gz 
cd kubernetes/server/bin
cp hyperkube kubectl ~/kube/bin/
```

Add the binaries to the `$PATH`, so that we can run them from everywhere. Note that this only sets the path for the session; add this line to `~/.profile` for a permanent setting.

```bash
$ PATH="$HOME/kube/bin:$PATH"
```

### Install CNI Plugins ###
The basic CNI plugins are required for Kubernetes networking. They can be downloaded from [here](https://github.com/containernetworking/plugins/releases) and should be extracted to `/opt/cni/bin/`:

```bash
DOWNLOAD_DIR="${HOME}/kube/cni-plugins"
CNI_BIN="/opt/cni/bin/"
mkdir ${DOWNLOAD_DIR}
cd $DOWNLOAD_DIR
curl -L $(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | grep browser_download_url | grep 'amd64.*tgz' | head -n 1 | cut -d '"' -f 4) -o cni-plugins-amd64.tgz
tar -xvzf cni-plugins-amd64.tgz
sudo mkdir -p ${CNI_BIN}
sudo cp -r !(*.tgz) ${CNI_BIN}
ls ${CNI_BIN}
```


### Certificates ###
First, acquire the local IP address, either via `ifconfig` or:

```bash
$ ip addr show dev eth0
```

if the interface name is known. It will be referenced a lot throughout this process; setting it to an environmental variable makes things easier. The following snippet sets it temporarily; if the session ends or shell closes, it needs to be set again.

```bash
$ MASTER_IP=10.123.45.67   # example! replace
```

Prepare the certificates that will be used for nodes to communicate in the cluster:

```bash
cd ~/kube/certs
chmod u+x generate-certs.sh
./generate-certs.sh $MASTER_IP
```

### Prepare Manifests & Addons ###
Generate a set of YAML files that specify Kubernetes system pods by passing the master IP address and *full* cluster CIDR to the Python script in the `manifest` folder:

```bash
cd ~/kube/manifest
./generate.py $MASTER_IP --cluster-cidr 192.168.0.0/16
```

(Re)move the Python script so that Kubernetes doesn't mistake it for a manifest; this will cause problems later if not done.

> [!Important]  
> If the Kubernetes version has diverged from this guide, use the various versioning flags on the script (such as `--api-version`) to [customize the image](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/hyperkube-amd64) that the pods deploy. Not all of the manifests use the same image and have different versioning schemas (notably, `etcd` and the addon manager).


#### Manifest Customization ####
At this point, setup-specific changes may be desirable. For example, there may be a need to manually assign subnets to nodes, rather than letting them be managed by Kubernetes automatically. This specific configuration has an option in the script (see `--help` for an explanation of the `--im-sure` parameter):

```bash
./generate.py $MASTER_IP --im-sure
```

Any other custom configuration options will require manual modification of the generated manifests.


### Configure & Run Kubernetes ###
Configure Kubernetes to use the generated certificates. This will create a configuration at `~/.kube/config`:

```bash
cd ~/kube
./configure-kubectl.sh $MASTER_IP
```

Now, copy the file to where the pods will later expect it to be:

```bash
mkdir ~/kube/kubelet
sudo cp ~/.kube/config ~/kube/kubelet/
```

The Kubernetes "client", `kubelet`, is ready to be started. The following scripts both run indefinitely; open another terminal session after each one to keep working:

```bash
cd ~/kube
sudo ./start-kubelet.sh
```

Run the Kubeproxy script, passing the partial cluster CIDR:

```bash
cd ~/kube
sudo ./start-kubeproxy.sh 192.168
```


> [!Important]  
> This will be the *full* expected /16 CIDR under which the nodes will fall, *even if there is non-Kubernetes traffic on that CIDR.* Kubeproxy *only* applies to Kubernetes traffic to the *service* subnet, so it should not interfere with other hosts' traffic.

> [!Note]  
> These scripts can be daemonized. This guide only covers running them manually, as that's the most useful during setup to catch errors.


## Verifying the Master ##
After a few minutes, the system should be in the following state:

  - Under `docker ps`, there will be ~23 worker and pod containers.
  - Calling `kubectl cluster-info` will show information about the Kubernetes master API server in addition to DNS and Heapster addons.
  - `ifconfig` will show a new interface `cbr0` with the chosen cluster CIDR.

