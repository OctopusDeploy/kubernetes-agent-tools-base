#!/bin/bash

if [ "$TARGETARCH" = "amd64" ]; then
  platform=x64
else
  platform=$TARGETARCH
fi

curl -L -o /tmp/powershell.tar.gz "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-${TARGETOS}-${platform}.tar.gz"