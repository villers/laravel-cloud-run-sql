# Deploy laravel to cloud run

Let's build a demo application, using Google Cloud components and laravel

App uses:

 * [Laravel 7.x](https://laravel.com/docs/7.x/installation) as the web framework
 * [Google Cloud Run](https://cloud.google.com/run/) as the hosting platform
 * [Google Cloud SQL](https://cloud.google.com/sql/) as the managed database
 * [Google Cloud Build](https://cloud.google.com/cloud-build/) for build and deployment automation
 * [Google Secret Manager](https://cloud.google.com/secret-manager/) for managing encrypted values

*This repo serves as a proof of concept of showing how you can piece all the above technologies together into a working project.*

## Steps

[Try the application locally](docs/00-test-local.md) *optional*

Manual deployment:

1. [Setup Google Cloud Platform environment](docs/10-setup-gcp.md)
2. [Deploy with Terraform](docs/20-deloyment.md)
3. [Cleanup your project resources](docs/30-cleanup.md)
