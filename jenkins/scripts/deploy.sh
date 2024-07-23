set -x
docker build -t my-django-app ./webapp
docker run -d -p 8000:8000 --name my-django-app -v /mnt/Question/src:/code my-django-app
sleep 1
set +x

echo 'Now...'
echo 'Visit http://127.0.0.1:8000 to see your Django application in action.'