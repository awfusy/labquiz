#!/usr/bin/env sh

set -x

# Stop and remove the existing container if it exists
docker kill my-django-app || true
docker rm my-django-app || true

# Build the Docker image for the Django app
docker build -t my-django-app ./webapp

# Run the Docker container for the Django app
docker run -d -p 8000:8000 --name my-django-app -v /mnt/Question/src:/code my-django-app

sleep 1
set +x

echo 'Now...'
echo 'Visit http://127.0.0.1:8000 to see your Django application in action.'
