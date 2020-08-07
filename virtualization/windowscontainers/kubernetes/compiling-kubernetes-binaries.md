---
title: Compiling Kubernetes Binaries
author: gkudra-msft
ms.author: gekudray
ms.date: 11/02/2018
ms.topic: how-to

description: Compiling and cross-compiling Kubernetes binaries from source.
keywords: kubernetes, 1.12, linux, compile
---

# Compiling Kubernetes Binaries #
Compilation of Kubernetes requires a working Go environment. This page goes through several ways to compile Linux binaries and cross-compile Windows binaries.
> [!NOTE]
> This page is completely voluntary and only included for interested Kubernetes developers who want to experiment with the latest & greatest source code.

> [!tip]
> To receive notifications about the newest developments you can subscribe to [@kubernetes-announce](https://groups.google.com/forum/#!forum/kubernetes-announce).

## Installing Go ##
For simplicity, this goes through installing Go in temporary, custom location:

```bash
cd ~
wget https://redirector.gvt1.com/edgedl/go/go1.11.1.linux-amd64.tar.gz -O go1.11.1.tar.gz
tar -vxzf go1.11.1.tar.gz
mkdir gopath
export GOROOT="$HOME/go"
export GOPATH="$HOME/gopath"
export PATH="$GOROOT/bin:$PATH"
```

> [!Note]
> These set the environmental variables for your session. Add the `export`s to your `~/.profile` for a permanent setting.

Run `go env` to ensure the paths have been properly set. There are several options for building Kubernetes binaries:

  - Build them [locally](#build-locally).
  - Generate the binaries using [Vagrant](#build-with-vagrant).
  - Leverage the [standard containerized build scripts](https://github.com/kubernetes/kubernetes/tree/master/build#key-scripts) in the Kubernetes project. For this, follow the steps for [building locally](#build-locally) up to the `make` steps, then use the linked instructions.

To copy Windows binaries to their respective nodes, use a visual tool like [WinSCP](https://winscp.net/eng/download.php) or a command-line tool like [pscp](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to transfer them to the `C:\k` directory.


## Building locally ##
> [!Tip]
> If you run into "permission denied" errors, these can be avoided by building the Linux `kubelet` first, per the note in [`acs-engine`](https://github.com/Azure/acs-engine/blob/master/scripts/build-windows-k8s.sh#L176):
>
> _Due to what appears to be a bug in the Kubernetes Windows build system, one has to first build a Linux binary to generate `_output/bin/deepcopy-gen`. Building to Windows w/o doing this will generate an empty `deepcopy-gen`._

First, retrieve the Kubernetes repository:

```bash
KUBEREPO="k8s.io/kubernetes"
go get -d $KUBEREPO
# Note: the above command may spit out a message about
#       "no Go files in...", but it can be safely ignored!
cd $GOPATH/src/$KUBEREPO
```

Now, checkout the branch to build from and build the Linux `kubelet` binary. This is necessary to avoid the Windows build errors noted above. Here, we will use `v1.12.2`. After the `git checkout`, you can apply pending PRs, patches, or make other modifications for the custom binaries.

```bash
git checkout tags/v1.12.2
make clean && make WHAT=cmd/kubelet
```

Finally, build the necessary Windows client binaries (the last step may vary, depending on where the Windows binaries should be retrieved from later):

```bash
KUBE_BUILD_PLATFORMS=windows/amd64 make WHAT=cmd/kubectl
KUBE_BUILD_PLATFORMS=windows/amd64 make WHAT=cmd/kubelet
KUBE_BUILD_PLATFORMS=windows/amd64 make WHAT=cmd/kube-proxy
cp _output/local/bin/windows/amd64/kube*.exe ~/kube-win/
```

The steps to building Linux binaries are identical; just leave off the `KUBE_BUILD_PLATFORMS=windows/amd64` prefix to the commands. The output directory will be `_output/.../linux/amd64` instead.


## Build with Vagrant ##
There is a Vagrant setup available [here](https://github.com/Microsoft/SDN/tree/master/Kubernetes/linux/vagrant). Use it to prepare a Vagrant VM, then execute these commands inside it:

```bash
DIST_DIR="${HOME}/kube/"
SRC_DIR="${HOME}/src/k8s-main/"
mkdir ${DIST_DIR}
mkdir -p "${SRC_DIR}"

git clone https://github.com/kubernetes/kubernetes.git ${SRC_DIR}

cd ${SRC_DIR}
git checkout tags/v1.12.2
KUBE_BUILD_PLATFORMS=linux/amd64   build/run.sh make WHAT=cmd/kubelet
KUBE_BUILD_PLATFORMS=windows/amd64 build/run.sh make WHAT=cmd/kubelet
KUBE_BUILD_PLATFORMS=windows/amd64 build/run.sh make WHAT=cmd/kube-proxy
cp _output/dockerized/bin/windows/amd64/kube*.exe ${DIST_DIR}

ls ${DIST_DIR}
```

