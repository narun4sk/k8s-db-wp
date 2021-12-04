## Running Wordpress App and HA MySQL Cluster on Kubernetes

This exercise is based on `k3d` - a lightweight wrapper to run `k3s` (Rancher Lab’s minimal Kubernetes distribution) in docker. For the flawless experience it's recommended to install `k3d` according to the official guidelines: https://k3d.io/v5.2.0/#installation

### Bootstrap Kubernetes cluster

In this step you will deploy 3x workers (2 labeled `role: db`, 1 labeled `role: app`) and 1x control plane server. Ingress will be exposed on the `8081` TCP port on the host PC. Additionally `k3d_cluster.sh` script will create `./mysql-data` directory for storing MySQL PersistentVolume data.

```
$ ./k3d_cluster.sh my-k8s
mkdir: created directory '/home/tst/k8s-db-wp/mysql-data'
mkdir: created directory '/home/tst/k8s-db-wp/mysql-data/data-0'
mkdir: created directory '/home/tst/k8s-db-wp/mysql-data/data-1'
INFO[0000] portmapping '8081:80' targets the loadbalancer: defaulting to [servers:*:proxy agents:*:proxy]
INFO[0000] Prep: Network
INFO[0000] Created network 'k3d-my-k8s'
INFO[0000] Created volume 'k3d-my-k8s-images'
INFO[0000] Starting new tools node...
INFO[0000] Starting Node 'k3d-my-k8s-tools'
INFO[0001] Creating node 'k3d-my-k8s-server-0'
INFO[0001] Creating node 'k3d-my-k8s-agent-0'
INFO[0001] Creating node 'k3d-my-k8s-agent-1'
INFO[0001] Creating node 'k3d-my-k8s-agent-2'
INFO[0001] Creating LoadBalancer 'k3d-my-k8s-serverlb'
INFO[0001] Using the k3d-tools node to gather environment information
INFO[0001] HostIP: using network gateway...
INFO[0001] Starting cluster 'my-k8s'
INFO[0001] Starting servers...
INFO[0001] Starting Node 'k3d-my-k8s-server-0'
INFO[0007] Starting agents...
INFO[0007] Starting Node 'k3d-my-k8s-agent-1'
INFO[0007] Starting Node 'k3d-my-k8s-agent-0'
INFO[0007] Starting Node 'k3d-my-k8s-agent-2'
INFO[0019] Starting helpers...
INFO[0020] Starting Node 'k3d-my-k8s-serverlb'
INFO[0026] Injecting '192.168.80.1 host.k3d.internal' into /etc/hosts of all nodes...
INFO[0026] Injecting records for host.k3d.internal and for 5 network members into CoreDNS configmap...
INFO[0027] Cluster 'my-k8s' created successfully!
INFO[0027] You can now use it like this:
kubectl cluster-info
```

### Set up base variables

Modify `./env_vars.sh` as required:
```
export DB_USER=db_user
export DB_PASS=db_random_pass
export DB_NAME=wordpress
export DB_NAMESPACE=mysql
export DB_DEPLOYMENT=mysql-cluster
export WP_USER=wp_user
export WP_PASS=wp_random_pass
export WP_NAMESPACE=wordpress
export WP_DEPLOYMENT=wordpress
```

### Inspect deployment manifests

```
$ ./mysql.sh template
....

$ ./wordpress.sh template
....
```

### Deploy MySQL Cluster

```
$ ./mysql.sh
NAME: mysql-cluster
LAST DEPLOYED: Sun Dec  5 12:17:57 2021
NAMESPACE: mysql
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

### Deploy Wordpress

```
$ ./wordpress.sh
NAME: wordpress
LAST DEPLOYED: Sun Dec  5 12:23:03 2021
NAMESPACE: wordpress
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: wordpress
CHART VERSION: 12.2.3
APP VERSION: 5.8.2
....
```

### Validate deployment

You may validate the deployment by opening the browser and navigating it to the http://localhost:8081

### Remove Kubernetes cluster

Once you're done with testing you may delete k8s cluster created in the first step:

```
k3d cluster delete my-k8s
```
