# Deployment

To start with, you'll need to [install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) for your operating system.

Once that's setup, you'll need to create a [new service account](https://www.terraform.io/docs/providers/google/getting_started.html#adding-credentials) that has Owner rights to your project, and [export an authentication key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) to that service account that Terraform can use.


```shell,exclude
# Select your project
export REGION=europe-west1
export SERVICE_NAME=serviceName
export PROJECT_ID=YourProjectID
export INSTANCE_NAME=serviceName
gcloud config set project $PROJECT_ID

# Create the service account
gcloud iam service-accounts create deployer \
    --display-name "Terraform Service Account"

# Grant editor permissions (lower than roles/owner)
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:deployer@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/owner

# create and save a local private key
gcloud iam service-accounts keys create ~/terraform-key.json \
  --iam-account deployer@${PROJECT_ID}.iam.gserviceaccount.com

# store location of private key in environment that terraform can use
export GOOGLE_APPLICATION_CREDENTIALS=~/terraform-key.json

# activate our previously created service account
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
```

---

## Without service account

```shell
gcloud auth application-default login
```

---

🤔 Didn't we already do this authentication step?

We did, back in [the GCP setup section](10-setup-gcp.md); we authenicated to let `gcloud` act as "us". Us, in this case, is your login to the Google Cloud Console. There you get the Project Owner role, which is universal admin rights. We don't want Terraform to have that level of control. Instead the Editor role gives access to do most things, but not the ability to grant roles to others.

---

### Provision Infrastructure

Before provisioning, you need to enable the following APIs:

- Google Container Registry
- Identity and Access Management (IAM)
- Cloud Resource Manager

Go to `APIs & Services > Library`, search for the APIs and ensure they are enabled. If already enabled, you'll see an `API enabled` info.

---

Let's build our first Docker image and upload it to Google Docker Registry

```shell
docker build -f .cloud/docker/php/Dockerfile -t eu.gcr.io/${PROJECT_ID}/${SERVICE_NAME} .
```

Now that image is built, we have to upload it to Google Registry. The image will be used from Google Registry when deploying on cloud with Terraform.

```shell
# authenticate to registry so we are allowed to push
gcloud auth configure-docker

# push it
docker push eu.gcr.io/${PROJECT_ID}/${SERVICE_NAME}
```

---

We've provided the Terraform files in `.cloud/terraform/`, so navigate there and initialise:

```shell
cd .cloud/terraform
terraform init
```

Your terraform version must be > 0.12

Then apply the configurations:

```shell
terraform apply
```

Without specifying any other flags, this command will prompt you for some variables (with details about what's required, see `variables.tf` for the full list), and to check the changes that will be applied (which can be checked without potentially applying with `terraform plan`).

You can specify your variables using [command-line flags](https://learn.hashicorp.com/terraform/getting-started/variables.html#command-line-flags), which would look something like this:

```shell,exclude
terraform apply \
  -var "region=${REGION}" \
  -var "service=${SERVICE_NAME}" \
  -var "project=${PROJECT_ID}" \
  -var "instance_name=${INSTANCE_NAME}"
```

### Deployment cloud run only and play migrations

```shell
gcloud builds submit \
  --project ${PROJECT_ID} \
  --config .cloudbuild/build-migrate-deploy.yaml \
  --substitutions _APP_ENV=prod,_APP_DEBUG=false,_SERVICE=${SERVICE_NAME},_REGION=${REGION},_INSTANCE_NAME=${INSTANCE_NAME}
```

### Run your seeder

```shell
gcloud builds submit \
  --project ${PROJECT_ID} \
  --config .cloudbuild/seeder-deploy.yaml \
  --substitutions _APP_ENV=prod,_APP_DEBUG=false,_SERVICE=${SERVICE_NAME},_REGION=${REGION},_INSTANCE_NAME=${INSTANCE_NAME}
```

Next step: 3. [Cleanup your project resources](30-cleanup.md)
