param(
[string]$sqldata="c:\sql",
[string]$pguser
)

$ErrorActionPreference = "Stop"

# create database cluster folder
pg_ctl init -U $pguser

# reconfigure postgresql for remote access (from default localhost-only)
add-content (join-path $sqldata "pg_hba.conf") "`nhost all all 0.0.0.0/0 trust"
add-content (join-path $sqldata "postgresql.conf") "`nlisten_addresses = '*'"

# create and start service
pg_ctl register

#wait for service to start
(Get-Service 'PostgreSQL').WaitForStatus('Running', '00:00:30')

# create role (since this is not done by upstream "pg_ctl init")
createuser -s -r $pguser
