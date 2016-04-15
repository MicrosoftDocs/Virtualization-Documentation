FROM windowsservercore
LABEL Description="MongoDB" Vendor="MongoDB, Inc." Version="3.0.4"
ADD sources /build
RUN msiexec /i C:\build\mongodb-win32-x86_64-2008plus-ssl-3.0.7-signed.msi /qn /l*v C:\build\mongodb-win32-x86_64-2008plus-ssl-3.0.7-signed.log & mkdir C:\data\db & mkdir C:\data\log & del C:\build\mongodb-win32-x86_64-2008plus-ssl-3.0.7-signed.msi
WORKDIR /data
CMD ["mongod"]
