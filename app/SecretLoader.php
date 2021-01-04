<?php


namespace App;


use Google\ApiCore\ApiException;
use Google\Cloud\SecretManager\V1\SecretManagerServiceClient;

class SecretLoader
{
    public static function load(array $names): void
    {
        $client = new SecretManagerServiceClient();

        foreach ($names as $name) {
            if (isset($_ENV[$name])) {
                continue;
            }

            try {
                $secret = $client::secretVersionName(getenv('PROJECT_ID'), $name, 'latest');
                $response = $client->accessSecretVersion($secret);
                $payload = $response->getPayload();

                if ($payload) {
                    $_ENV[$name] = $payload->getData();
                }
            } catch (ApiException $e) {

            } finally {
                $client->close();
            }
        }
    }
}
