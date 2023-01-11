TEAMCITY SERVER
===============

This helm chart installs [TeamCity server](https://www.jetbrains.com/teamcity/).


### Configuration
Please change the values.yaml according to your setup

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `serviceAccount.create`   | Specifies whether a ServiceAccount should be created | `true`                                |
| `serviceAccount.name`     | The name of the ServiceAccount to create             | Generated using the fullname template |
| `rbac.create`             | Specifies whether RBAC resources should be created   | `true`                                |
| `rbac.role.rules`         | Rules to create                                      | `[]`                                  |
| `replicaCount`            | Replica count for TeamCity deployment                | `1`                                   |
| `agent.replicaCount`      | Replica count for TeamCity agent deployment          | `1`                                   |
| `agent.image.pullPolicy`  | Container pull policy                                | `IfNotPresent`                        |
| `agent.image.repository`  | Container image                                      | `jetbrains/teamcity-server`           |
| `agent.resources.limits.cpu`      | TeamCity agent cpu limit                     | `800m`                                |
| `agent.resources.limits.memory`   | TeamCity agent memory limit                  | `968Mi`                               |
| `agent.resources.requests.cpu`    | TeamCity agent initial cpu request           | `600m`                                |
| `agent.resources.requests.memory` | TeamCity agent initial memory request        | `968Mi`                               |
| `server.replicaCount`      | Replica count for TeamCity server deployment        | `1`                                   |
| `server.image.pullPolicy`  | Container pull policy                               | `IfNotPresent`                        |
| `server.image.repository`  | Container image                                     | `jetbrains/teamcity-server`           |
| `server.image.version`     | Container tag                                       |  `2018.1.5`                           |
| `server.resources.limits.cpu`      | TeamCity cpu limit                          | `800m`                                |
| `server.resources.limits.memory`   | TeamCity memory limit                       | `968Mi`                               |
| `server.resources.requests.cpu`    | TeamCity initial cpu request                | `600m`                                |
| `server.resources.requests.memory` | TeamCity initial memory request             | `968Mi`                               |
| `server.livenessProbe.enabled`              | Enable liveness probe                     | `true`                         |
| `server.livenessProbe.path`                 | Path for liveness probe                   | `/js/polyfills.js`             |
| `server.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated  | 180                            |
| `server.livenessProbe.periodSeconds`        | How often to perform the probe            | 10                             |
| `server.livenessProbe.timeoutSeconds`       | When the probe times out                  | 10                             |
| `server.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | 1 |
| `server.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 10 |
| `server.readinessProbe.enabled`             | would you like a readinessProbe to be enabled | `true`                     |
| `server.readinessProbe.path`                | Path for readiness probe                  | `/js/polyfills.js`             |
| `server.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | 60                             |
| `server.readinessProbe.periodSeconds`       | How often to perform the probe            | 10                             |
| `server.readinessProbe.timeoutSeconds`      | When the probe times out                  | 10                             |
| `server.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | 1 |
| `server.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 10 |
| `service.name`                  | TeamCity service name to be set in Nginx configuration | `teamcity`                    |
| `service.type`                              | TeamCity service type                      | `ClusterIP`                   |
| `service.loadBalancerIP`                    | TeamCity service load balancer IP address  | ``                            |
| `service.port`                              | TeamCity service external port             | `8111`                        |
| `service.annotations`                       | TeamCity service annotations               | `{}`                          |
| `ingress.enabled`                           | If true, TeamCity Ingress will be created  | `false`                       |
| `ingress.defaultBackend.enabled`            | If true, TeamCity Ingress default backend will be created | `true`         |
| `ingress.annotations`                       | TeamCity Ingress annotations               | `{}`                          |
| `ingress.hosts`                             | TeamCity Ingress hostnames                 | `[]`                          |
| `ingress.tls`                               | TeamCity Ingress TLS configuration (YAML)  | `[]`                          |
| `pvc.agent.enabled` | Indicates whether a TeamCity agent data volume should be used      | `true`                        |
| `pvc.agent.name`            | The name of the agent data volume to create        | Generated using the fullname template | 
| `pvc.agent.storageClass`    | A storage class to use for the agent data volume           | `default`                     |
| `pvc.agent.storageSize`     | An agent data volume size                                  | `1Gi`                         |
| `pvc.server.enabled` | Indicates whether a TeamCity server data volume should be used    | `true`                        |
| `pvc.server.name`            | The name of the server data volume to create      | Generated using the fullname template | 
| `pvc.server.storageClass`    | A storage class to use for the server data volume         | `default`                     |
| `pvc.server.storageSize`     | An server data volume size                                | `1Gi`                         |


## How to
```
helm install --name teamcity ./helm-teamcity
```

## Author

 Dmitrii Ageev <d.ageev@gmail.com>
 
