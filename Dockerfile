# Build ONI-Modloader using a Docker container
# Supports cross-platform builds via Docker Buildx
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# 使用阿里云镜像
# 删掉原来的 deb 源并改用阿里云
RUN rm -f /etc/apt/sources.list /etc/apt/sources.list.d/* && \
    cat <<'EOF' > /etc/apt/sources.list
deb http://mirrors.aliyun.com/debian bullseye main contrib non-free
deb http://mirrors.aliyun.com/debian-security bullseye-security main contrib non-free
deb http://mirrors.aliyun.com/debian bullseye-updates main contrib non-free
EOF
RUN apt-get update && \
    apt-get install -y mono-complete curl unzip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

# Download required Unity and JetBrains dependencies
RUN curl -L -o /tmp/UnityEngine.CoreModule.nupkg https://api.nuget.org/v3-flatcontainer/unityengine.coremodule/2020.3.1/unityengine.coremodule.2020.3.1.nupkg \ 
    && curl -L -o /tmp/JetBrains.Annotations.nupkg https://api.nuget.org/v3-flatcontainer/jetbrains.annotations/2025.2.0/jetbrains.annotations.2025.2.0.nupkg \ 
    && mkdir /deps \ 
    && unzip -q /tmp/UnityEngine.CoreModule.nupkg -d /deps/core \ 
    && unzip -q /tmp/JetBrains.Annotations.nupkg -d /deps/jetbrains \ 
    && cp /deps/core/lib/net48/UnityEngine.CoreModule.dll Source/lib/UnityEngine.CoreModule.dll \ 
    && cp /deps/jetbrains/lib/net20/JetBrains.Annotations.dll Source/lib/JetBrains.Annotations.dll

# Build the solution using xbuild (Mono's MSBuild)
RUN xbuild Source/ModLoader.sln
