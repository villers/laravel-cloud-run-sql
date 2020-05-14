# Setup Google Cloud Platform environment

*The steps listed below are common to doing anything on Google Cloud. If you run into any issues, you can find many step-by-step tutorials on the topic.*

---

In order to deploy on Google Cloud, you need to sign up (if you haven't already).

To sign up, go to [cloud.google.com](https://cloud.google.com/) and click "Get started". 

Once you have signed up, you need to create a new project.

Notes: 

* Project names are *globally unique* -- no one else can have the same project name as you. 
* Project names cannot be changed after they have been created.
* We're going to be referring to this name as `PROJECT_ID`. A lot. 

You will also need to setup this project against a Billing Account. Some of the components we will provision will cost money, but new customers do get [free credits](https://cloud.google.com/free)

---

We're also going to be using the command line utility (CLI) for Google Cloud, `gcloud`, wherever possible. 

Go to the [`gcloud` install website](https://cloud.google.com/sdk/docs/#install_the_latest_cloud_tools_version_cloudsdk_current_version) download a version for your operating system. You'll then be guided to install the tool and then initialise it (which handles logging into Google Cloud, so that `gcloud` can perform operations as you.)

To test your `gcloud` CLI works and is up to date: 

```shell,exclude
gcloud --version
```

If you see a "Updates are available" prompt, follow those update instructions. 

---

Next, we need to set our project ID in both the command-line and as an environment variable. 


Setting this as an environment variable will mean when you copy and paste code from this tutorial, it will Just Work(tm). Note that this variable will only be set for your current terminal. Run it again if you open a new terminal window. 

```shell
export PROJECT_ID=YourProjectID
gcloud config set project $PROJECT_ID
```


Then u should login to your gcloud account 

```
gcloud auth login
```

Next step: [Deploy with Terraform](20-deloyment.md)
