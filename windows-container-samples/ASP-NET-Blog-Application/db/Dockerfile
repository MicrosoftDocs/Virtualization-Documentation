FROM microsoft/mssql-server-2014-express-windows

# SQL environmental variables
ENV sa_password "Password123"
ENV attach_dbs "[]"

# Copy SQL scripts for setting up blog database and tables
COPY . /

WORKDIR /

# Create blog application database and tables
RUN powershell sqlcmd -S localhost,1433 -i Setup-blogdatabase.sql
RUN powershell sqlcmd -S localhost,1433 -i Setup-blogtables.sql

CMD powershell ./start -sa_password %sa_password% -attach_dbs \"%attach_dbs%\" -Verbose
