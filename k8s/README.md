# Trillo on EKS

1. Create cluster VPC
    - https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-vpc-sample.yaml and
        - Stack name: 
        - VpcBlock: 
        - Subnet01Block: 
        - Subnet02Block: 
        - Subnet03Block: 
    - note `SecurityGroups`, `VpcId` and `SubnetIds`

2. Create IAM role - `eksServiceRole`

3. Create EKS Cluster
    - Cluster name
    - Kubernetes version
    - Role ARN:  Amazon EKS Service Role `eksServiceRole`
    - VPC: `VpcId`
    - Subnets: `SubnetIds`
    - Security Groups:  `SecurityGroups`

4. Launch and Configure EKS Worker Nodes
    - https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-nodegroup.yaml
        - Stack name
        - ClusterName:   
        - ClusterControlPlaneSecurityGroup: 
        - NodeGroupName: 
        - NodeAutoScalingGroupMinSize: 
        - NodeAutoScalingGroupMaxSize:
        - NodeInstanceType:
        - NodeImageId: us-west-2 --> `ami-73a6e20b`, us-east-1 --> `ami-dea4d5a1`

5. Configure kubectl for Amazon EKS
    - install kubectl
    - install heptio-authenticator-aws
    - aws eks describe-cluster --name <devel>  --query cluster.endpoint
    - aws eks describe-cluster --name devel  --query cluster.certificateAuthority.data
    - ... TODO
    - export KUBECONFIG=$KUBECONFIG:~/.kube/config-devel
    
6. Add-ons
    - Dashboard

7. Create EFS volume in AWS console and update `trillo-persistent-volumes.yaml`

8. Launch the Application
    - ```
      kubectl apply -f trillo-namespace.yaml
      kubectl apply -f trillo-secrets.yaml
      kubectl apply -f trillo-rt-service.yaml
      kubectl apply -f trillo-ds-service.yaml
      kubectl apply -f trillo-persistent-volumes.yaml
      kubectl apply -f trillo-rt-controller.yaml
      kubectl apply -f trillo-ds-controller.yaml
      kubectl -n trillo get services
      kubectl -n trillo get pods
      ```
9. Delete the Application
    - ```
      kubectl delete -f trillo-ds-controller.yaml
      kubectl delete -f trillo-rt-controller.yaml
      kubectl delete -f trillo-persistent-volumes.yaml
      kubectl delete -f trillo-ds-service.yaml
      kubectl delete -f trillo-rt-service.yaml
      kubectl delete -f trillo-secrets.yaml
      kubectl delete -f trillo-namespace.yaml
      ```

## References

- [Kubernetes](https://kubernetes.io)
- [EKS Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [K8s Addons](https://kubernetes.io/docs/concepts/cluster-administration/addons/)
- [K8S AWS cloud provider](https://v1-10.docs.kubernetes.io/docs/concepts/cluster-administration/cloud-providers/#aws)
- https://kubernetes.io/docs/concepts/storage/storage-classes/#aws
