#!/bin/bash

# provided directly by kadalu project at https://github.com/kadalu/kadalu/blob/devel/extras/scripts/cleanup

kubectl -nkadalu delete StatefulSet kadalu-csi-provisioner
kubectl -nkadalu delete ClusterRoleBinding kadalu-csi-provisioner
kubectl -nkadalu delete ServiceAccount kadalu-csi-provisioner
kubectl -nkadalu delete ClusterRole kadalu-csi-provisioner
kubectl -nkadalu delete Role kadalu-csi-provisioner
kubectl -nkadalu delete RoleBinding kadalu-csi-provisioner

kubectl -nkadalu delete DaemonSet kadalu-csi-nodeplugin
kubectl -nkadalu delete ClusterRoleBinding kadalu-csi-nodeplugin
kubectl -nkadalu delete ClusterRole kadalu-csi-nodeplugin
kubectl -nkadalu delete ServiceAccount kadalu-csi-nodeplugin

kubectl delete CSIDriver kadalu
kubectl get Service -nkadalu | awk '{print $1}' | xargs kubectl -nkadalu delete Service
kubectl get StatefulSet -nkadalu | awk '{print $1}' | xargs kubectl -nkadalu delete StatefulSet
kubectl get storageclass | grep kadalu | awk '{print $1}' | xargs kubectl delete storageclass

# Operator
kubectl delete -nkadalu CustomResourceDefinition kadalustorages.kadalu-operator.storage
kubectl delete -nkadalu ClusterRole pod-exec
kubectl delete -nkadalu ClusterRole kadalu-operator
kubectl delete -nkadalu ServiceAccount kadalu-operator
kubectl delete -nkadalu ClusterRoleBinding kadalu-operator
kubectl delete -nkadalu Deployment kadalu-operator

# CSIDriver
kubectl delete CSIDriver kadalu

kubectl delete namespace kadalu