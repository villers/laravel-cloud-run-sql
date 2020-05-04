# Deploy laravel to cloud run

## Create service account

```shell
cd .cloud/terraform

# Configure project
$ export PROJECT_ID=cloud-run-as-code

# Create the service account
gcloud iam service-accounts create deployer --project ${PROJECT_ID}

# Grant editor permissions (lower than roles/owner)
gcloud projects add-iam-policy-binding cloud-run-as-code --member "serviceAccount:deployer@${PROJECT_ID}.iam.gserviceaccount.com" --role "roles/owner"

# create and save a local private key
gcloud iam service-accounts keys create service-account.json --iam-account deployer@${PROJECT_ID}.iam.gserviceaccount.com

# store location of private key in environment that terraform can use
export GOOGLE_CREDENTIALS=$(cat service-account.json)
```

## Without service account

```shell
gcloud auth application-default login
```

## Deploy infra

```shell
 terraform apply -var 'region=europe-west1' -var 'service=laravel-sandbox' -var 'project=cloud-run-as-code'  -var 'instance_name=laravel-sandbox4'
```

## Destroy infra

```shell
 terraform destroy -var 'region=europe-west1' -var 'service=laravel-sandbox' -var 'project=cloud-run-as-code'  -var 'instance_name=laravel-sandbox4'
```
