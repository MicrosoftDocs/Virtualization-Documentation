# Host-Gateway Mode #
One of the available options for Kubernetes networking is *host-gateway mode*, which entails the configuration of static routes between pod subnets on all nodes.


## Configuring Static Routes | Linux ##
For this, we use `iptables`. Replace (or set) the `$CLUSTER_PREFIX` variable with the short-hand subnet that all pods will use:

```bash
$CLUSTER_PREFIX="192.168"
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING ! -d $CLUSTER_PREFIX.0.0/16 \
              -m addrtype ! --dst-type LOCAL -j MASQUERADE
sudo sysctl -w net.ipv4.ip_forward=1
```

This only sets up basic NATing for the pods. Now, we need to make all traffic destined to pods go through the primary interface. Again, replace `$CLUSTER_PREFIX` variable as needed, and `eth0` if that applies:

```bash
sudo route add -net $CLUSTER_PREFIX.0.0 netmask 255.255.0.0 dev eth0
```

Finally, we need to add the next-hop gateway on a **per-node** basis. For example, if the first node is a Windows node on `192.168.1.0/16`, then:

```bash
sudo route add -net $CLUSTER.1.0 netmask 255.255.255.0 gw $CLUSTER.1.2 dev eth0
```

A similar route must be added *for* every node in the cluster, *on* every node in the cluster.


<a name="explanation-2-suffix"></a>
> [!Important]  
> For Windows nodes **only**, the gateway is the `.2` of the subnet. For Linux, it is likely always the `.1`. This anomaly is because the `.1` address is reserved as the gateway for the network adapter bridging the host network and the virtual pod network.


## Configuring Static Routes | Windows ##
For this, we use `New-NetRoute`. There is an automated script available, `AddRoutes.ps1`, in [this repository](https://github.com/Microsoft/SDN/blob/master/Kubernetes/windows/AddRoutes.ps1). You will need to know the IP address of the *Linux master*, and the default gateway of the Windows node's *external* adapter (not the pod gateway). Then:


```powershell
$url = "https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/windows/AddRoutes.ps1"
wget $url -o AddRoutes.ps1
./AddRoutes.ps1 -MasterIp 10.1.2.3 -Gateway 10.1.3.1
```
