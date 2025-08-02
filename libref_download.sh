#!/usr/bin/env bash
set -euo pipefail

# Download required Unity and JetBrains dependencies
curl -L -o /tmp/UnityEngine.CoreModule.nupkg \
  https://api.nuget.org/v3-flatcontainer/unityengine.coremodule/2020.3.1/unityengine.coremodule.2020.3.1.nupkg
curl -L -o /tmp/JetBrains.Annotations.nupkg \
  https://api.nuget.org/v3-flatcontainer/jetbrains.annotations/2025.2.0/jetbrains.annotations.2025.2.0.nupkg

# Extract libraries
mkdir -p /tmp/deps/core /tmp/deps/jetbrains
unzip -q /tmp/UnityEngine.CoreModule.nupkg -d /tmp/deps/core
unzip -q /tmp/JetBrains.Annotations.nupkg -d /tmp/deps/jetbrains

# Copy DLLs into project
cp /tmp/deps/core/lib/net48/UnityEngine.CoreModule.dll Source/lib/UnityEngine.CoreModule.dll
cp /tmp/deps/jetbrains/lib/net20/JetBrains.Annotations.dll Source/lib/JetBrains.Annotations.dll
