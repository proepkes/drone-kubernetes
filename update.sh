#!/bin/bash

if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ -z ${PLUGIN_KUBERNETES_USER} ]; then
  PLUGIN_KUBERNETES_USER="default"
fi

if [ ! -z ${PLUGIN_KUBERNETES_CLIENT_CERTIFICATE} ]; then
  KUBERNETES_CLIENT_CERTIFICATE=$PLUGIN_KUBERNETES_CLIENT_CERTIFICATE
fi

if [ ! -z ${PLUGIN_KUBERNETES_CLIENT_KEY} ]; then
  KUBERNETES_CLIENT_KEY=$PLUGIN_KUBERNETES_CLIENT_KEY
fi

if [ ! -z ${KUBERNETES_CLIENT_CERTIFICATE} ] && [ ! -z ${KUBERNETES_CLIENT_KEY} ]; then
    echo ${KUBERNETES_CLIENT_CERTIFICATE} | base64 -d > client-certificate.crt
    echo ${KUBERNETES_CLIENT_KEY} | base64 -d > client-key.crt
    cat client-certificate.crt
    echo "-----"
    kubectl config set-credentials default --client-certificate client-certificate.crt --client-key client-key.crt
else
    kubectl config set-credentials default --token=${KUBERNETES_TOKEN}
fi

if [ ! -z ${KUBERNETES_CERT} ]; then
  echo ${KUBERNETES_CERT} | base64 -d > ca.crt
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --certificate-authority=ca.crt
else
  echo "WARNING: Using insecure connection to cluster"
  kubectl config set-cluster default --server=${KUBERNETES_SERVER} --insecure-skip-tls-verify=true
fi

kubectl config set-context default --cluster=default --user=${PLUGIN_KUBERNETES_USER}
kubectl config use-context default

kubectl version
IFS=',' read -r -a DEPLOYMENTS <<< "${PLUGIN_DEPLOYMENT}"
for DEPLOY in ${DEPLOYMENTS[@]}; do
  echo Deploying ${DEPLOY} to $KUBERNETES_SERVER
  kubectl -n ${PLUGIN_NAMESPACE} rollout restart deployment/${DEPLOY}
done
