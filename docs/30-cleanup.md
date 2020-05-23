# Clean up

If you no longer want to keep your application running, you need to clean it up.

If you chose to create a new Google Cloud Platform project just for this app, then you can cleanup by deleting the entire project.


To avoid incurring charges to your Google Cloud Platform account for the resources used in this tutorial:
 * In the Cloud Console, go to the [Manage resources](https://console.cloud.google.com/cloud-resource-manager) page.
 * In the project list, select your project then click Delete.
 * In the dialog, type the project ID and then click Shut down to delete the project.

## Destroy all resources with terraform if you want keep your project

```shell
terraform destroy \
  -var "region=${REGION}" \
  -var "service=${SERVICE_NAME}" \
  -var "project=${PROJECT_ID}" \
  -var "instance_name=${SERVICE_NAME}"
```
