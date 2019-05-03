# Description:

Creates an image containing Django 2.2.

The microsoft/python is used as the base image.

This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t django:latest .
```

**Docker Run** 

This will start a container, display the Django version, and then exit. Modify the Dockerfile appropriately for application use. 

```
docker run -it 80:80 django
```

## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://github.com/django/django/blob/master/LICENSE

FROM python

LABEL Description="Django" Vendor="Django Software Foundation" Version="2.2"

RUN ["pip", "install", "Django==2.2"]

CMD ["django-admin --version"]
```


