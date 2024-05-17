# pre-requisites

```shell
# create GCP credentials json key and store it in root level with name tf-key.json

# create remote state bucket
$ export BUCKET_NAME=remote-state-mediawiki
$ gcloud storage buckets create gs://$BUCKET_NAME --location=us-central1

# Enable the following apis in the cloud console
# Network API, Compute API, Network Services API, Cloud Resource Manager API, Identity and Access Management (IAM) API, Service Networking API

```
```shell
$ terraform init

$ export PROJECT_ID=$(gcloud config get-value project)

$ terraform plan --var "password=root" --var "project_id=$PROJECT_ID" --var "remote_bucket_name=$$BUCKET_NAME" -out mediawiki.tfplan

$ terraform apply mediawiki.tfplan

# One can access the instance with http://Loadbalancer-publicip/wiki
```

# Potential future improvements

1. Instead of startup script, ansible can be used for configuration management.
2. Google cloud secret manager api can be used to fetch secrets in startup script rather than hardcoding user details.
3. Helm charts with lets-encrypt and certmanger approach is the alternative best approach instead of manging with VMs, as it promotes horizontal scalability and easy deployment/rollback strategies.
