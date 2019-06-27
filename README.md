# YoutubeEx

Before doing anything set docker flags to edge:

```shell
export DOCKER_BUILDKIT=1
export DOCKER_CLI_EXPERIMENTAL=enabled
```

Then use Skaffold to deploy the complete cluster:

```shell
skaffold dev
```
