iex "choco install ruby2.devkit -y"
if ($LASTEXITCODE -ne 0) {
  "error installing choco pkg"
  exit 1
}

# take remaining steps that choc package does not currently

cd \tools\devkit2
if ($LASTEXITCODE -ne 0) {exit 1}

iex "ruby dk.rb init"
if ($LASTEXITCODE -ne 0) {
  "error running ruby init"
  exit 1
}

add-content config.yml " - c:\ruby"

iex "ruby dk.rb install"
if ($LASTEXITCODE -ne 0) {
  "error running ruby install"
  exit 1
}


