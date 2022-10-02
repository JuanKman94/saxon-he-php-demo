1. Build the Docker image:
```shell 
docker build . -t saxon-demo
```
4. Run `php example.php` in the Docker container using:
```shell
docker run --platform=linux/amd64 -v "$(pwd)":/code saxon-demo
```
