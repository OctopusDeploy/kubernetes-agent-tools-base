# Kubernetes Agent Tools Base

This repo produces a container image that is used by the Kubernetes Agent to execute Kubernetes scripts. It contains the minimum required tooling to run Kubernetes workloads for Octopus Deploy.

Summary: The image packages `kubectl`, `helm`, `powershell` and `curl` on the base image `mcr.microsoft.com/dotnet/runtime-deps`.

## Updating versions

In the root of the directory there is a file, `versions.json` which contains information about what versions of Kubectl (and thus Kubernetes), Helm & Powershell are used to generate the images.
Under the `tools` object, there are 3 fields with versions arrays (`kubectl`,`helm`,`powershell`), which are used in a matrix to generate the images.

There is also a `latest` field that represents the kubernetes version that will be tagged with the `latest` tag.

### Tags

There are 3 tags being published

- `latest` - Assigned to the highest version of the Kubernetes supported by the Kubernetes agent.
- `{Kubectl Major Version}.{Kubectl Minor Version}-{Random6Chars}` - For each `kubectl` version, there will be an image with the Kubernetes major & minor version and random 6 char hash. Example: `1.31-X5msD0`.
- `kube{Kubectl Version}-helm{Helm Version}-pwsh{Powershell Version}-{Random6Chars}` - Contains all versions of the tools plus the revision. Example `kube1.31.1-helm3.16.1-pwsh7.4.5-X5msD0`. 

### Branch builds 

Branch builds will only be pushed the Octopus' Artifactory instance with a prerelease version `{artifactory-hostname}/octopusdeploy/kubernetes-agent-tools-base:{Kubectll Minor Version}.{Kubectl Minor Version}-{Sanitized Branch Name}-{Date}`
Example: `{artifactory-hostname}/octopusdeploy/kubernetes-agent-tools-base:1.29-tl-push-to-dockerhub-20240424041854`

The tags can be found from the logs in the Github action workflow under the step "Create Tag Version`