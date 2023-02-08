1. Build the Docker image:

```shell
docker build . -t php8-saxon
```

2. Run `php example.php` in the Docker container using:

```shell
docker run --platform=linux/amd64 -v "$PWD":/code php8-saxon
```

Or run an interactive shell to troubleshoot:

```shell
docker run --rm -it -v "$PWD":/code php8-saxon bash
```
