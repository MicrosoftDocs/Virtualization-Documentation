# postgres init, config and start-service

param(
[string]$sqldata="c:\sql",
[string]$pguser
)

$ErrorActionPreference = "Stop"

$svcname = "PostgreSQL"

# create database cluster folder
./pg_ctl init -U $pguser

# reconfigure postgresql for remote access (from default localhost-only)
add-content (join-path $sqldata "pg_hba.conf") "`nhost all all 0.0.0.0/0 trust"
add-content (join-path $sqldata "postgresql.conf") "`nlisten_addresses = '*'"

# create service (leaves set to 'Automatic' start)
./pg_ctl register
