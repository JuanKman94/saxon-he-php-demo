1. Build the Docker image using `docker build . -t saxon-demo`
2. Run `php example.php` in the Docker container using `docker run --platform=linux/amd64 -v "$(pwd)":/opt saxon-demo`
