# Kubernetes Agent Tools Base

This repo produces a container image that is used by the Kubernetes Agent to execute Kubernetes scripts. It contains the minimum required tooling to run Kubernetes workloads for Octopus Deploy.

Summary: The image packages `kubectl`, `helm` and `powershell` on the base image `mcr.microsoft.com/dotnet/runtime-deps`.

# Building and Pushing a image
Currently this is mostly a manual process which involves dispatching `build-and-publish-container-image` github workflow.
The steps are as follows:
1. Navigate to the ["build and publish container image" workflow](https://github.com/OctopusDeploy/kubernetes-agent-tools-base/actions/workflows/build-and-publish-container-image.yml) 
2. Click "Run workflow" 
3. Configure the workflow as follows 
* Branch: main or your desired branch - Only main will be pushed to dockerhub
* kubectl-version: This follows the Kubernetes versioning - values can be found on the [K8s git repo](https://github.com/kubernetes/kubernetes/tags)
* helm-version: This value will depend on the version of kubectl you have chosen, see the [helm compatibility table](https://helm.sh/docs/topics/version_skew/#supported-version-skew) to get the value.
* powershell-version: See the [Powershell github repo](https://github.com/PowerShell/PowerShell/tags) for a value or just use the default.
* tag-as-latest: If running against main and checked this will also push the image with the latest tag as well as the version tag.
4. Click "Run workflow"

# Accessing the image 
Mainline builds will be pushed to both dockerhub with the name `octopusdeploy/kubernetes-agent-tools-base:{Kubectll Minor Version}.{Kubectl Minor Version}`
Example Dockerhub: `octopusdeploy/kubernetes-agent-tools-base:1.29`  

Branch builds will only be pushed the Octopus' Artifactory instance with a prerelease version `{artifactory-hostname}/octopusdeploy/kubernetes-agent-tools-base:{Kubectll Minor Version}.{Kubectl Minor Version}-{Sanitized Branch Name}-{Date}`
Example: `{artifactory-hostname}/octopusdeploy/kubernetes-agent-tools-base:1.29-tl-push-to-dockerhub-20240424041854`

The tags can be found from the logs in the Github action workflow under the step "Create Tag Version`