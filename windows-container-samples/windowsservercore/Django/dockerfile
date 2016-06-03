# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://github.com/django/django/blob/master/LICENSE

FROM microsoft/python

LABEL Description="Django" Vendor="Django Software Foundation" Version="1.8.6"

RUN ["pip", "install", "Django==1.8.6"]

CMD ["django-admin --version"]