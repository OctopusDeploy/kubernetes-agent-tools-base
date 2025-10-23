# using a multi-stage dockerfile so that our resulting image is clean
FROM debian:latest AS deps

ARG KUBECTL_VERSION
ARG HELM_VERSION
ARG POWERSHELL_VERSION
ARG TARGETARCH
ARG TARGETOS

RUN apt update && apt install -y curl gzip

# install kubectl
RUN curl -LO "https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-${TARGETOS}-${TARGETARCH}.tar.gz"
RUN tar -zxvf "kubernetes-client-${TARGETOS}-${TARGETARCH}.tar.gz"
RUN mv ./kubernetes/client/bin/kubectl /bin/kubectl
RUN chmod 777 /bin/kubectl

# install helm
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz"
RUN tar -zxvf "helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz"
RUN mv "./${TARGETOS}-${TARGETARCH}/helm" /bin/helm
RUN chmod 777 /bin/helm

# install powershell
COPY ./download-powershell.sh .
RUN ./download-powershell.sh
RUN mkdir -p /opt/microsoft/powershell
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell
RUN chmod +x /opt/microsoft/powershell/pwsh

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0

# Take UID/GID 999 for ourselves before installing software-properties-common. In debian 12+ it sets up systemd-journal with GID 999
# but we want to keep 999 from older versions of our Octopus container; customers assign permissions to it.
# If we take the GID before installing software-properties-common, systemd-journal will get 998 instead.
RUN groupadd -g 999 octopus \
    && useradd -m -u 999 -g octopus octopus \
    && mkdir -p -m 0700 /run/user/999 \
    && chown octopus:octopus /run/user/999 \
    && echo 'octopus:265536:65536' >> /etc/subuid \
    && echo 'octopus:265536:65536' >> /etc/subgid

RUN apt update && apt install -y jq=1.6-2.1+deb11u1 curl

# copy exes from the builder container
COPY --from=deps /bin/kubectl /bin/kubectl
COPY --from=deps /bin/helm /bin/helm
COPY --from=deps /opt/microsoft/powershell /opt/microsoft/powershell
RUN ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
