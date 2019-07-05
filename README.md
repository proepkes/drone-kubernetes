# Kubernetes plugin for drone.io

This plugin restarts an existing Kubernetes deployment. This is useful when you use a Deployment with :latest-Tag, so K8s will download the newest Image.

Requires K8s-Cluster that is compatible with kubectl 1.15.0

## Usage  

```yaml
    - name: deploy to k8s 
    image: proepkes/drone-kubernetes-restart:latest
    environment:    
      KUBERNETES_CERT:    
        from_secret: KUBERNETES_CERT
      KUBERNETES_SERVER:    
        from_secret: KUBERNETES_SERVER
      KUBERNETES_CLIENT_CERTIFICATE:
        from_secret: KUBERNETES_CLIENT_CERTIFICATE
      KUBERNETES_CLIENT_KEY:
        from_secret: KUBERNETES_CLIENT_KEY
    settings:
      namespace: default
      deployment: <deployment-name>
```

## Required secrets

You can get these values from your .kube/config

Just paste the raw values, base64-decode is done by the plugin

```bash
    KUBERNETES_CERT

    KUBERNETES_SERVER

    KUBERNETES_CLIENT_CERTIFICATE

    KUBERNETES_CLIENT_KEY
```
