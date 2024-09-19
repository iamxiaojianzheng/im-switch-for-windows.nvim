$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$BuildDir = "build"

function Download-Prebuilt($feature)
{
  $REPO_OWNER = "iamxiaojianzheng"
  $REPO_NAME = "im-switch-for-windows.nvim"

  $SCRIPT_DIR = $PSScriptRoot
  # Set the target directory to clone the artifact
  $TARGET_DIR = Join-Path $SCRIPT_DIR "build"

  # Get the exe download URL
  $LATEST_RELEASE = Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest"
  $DOWNLOAD_URL = $LATEST_RELEASE.assets | Where-Object { $_.name -like "*im-switch.exe*" } | Select-Object -ExpandProperty browser_download_url

  # Create target directory if it doesn't exist
  if (-not (Test-Path $TARGET_DIR))
  {
    New-Item -ItemType Directory -Path $TARGET_DIR | Out-Null
  }

  # Download and extract the artifact
  # $TempFile = New-TemporaryFile | Rename-Item -NewName { "im-switch.exe" } -PassThru
  Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile "$BuildDir/im-switch.exe"
  # Expand-Archive -Path $TempFile -DestinationPath $TARGET_DIR -Force
  # Remove-Item $TempFile
}

function Main
{
  Set-Location $PSScriptRoot
  Write-Host "Downloading for $Version..."
  Download-Prebuilt $Version
  Write-Host "Completed!"
}

# Run the main function
Main
