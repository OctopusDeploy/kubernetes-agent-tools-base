# using a multi-stage dockerfile so that our resulting image is clean
FROM debian:latest as deps

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

RUN apt update && apt install -y jq=1.6-2.1

# copy exes from the builder container
COPY --from=deps /bin/kubectl /bin/kubectl
COPY --from=deps /bin/helm /bin/helm
COPY --from=deps /opt/microsoft/powershell /opt/microsoft/powershell
RUN ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
