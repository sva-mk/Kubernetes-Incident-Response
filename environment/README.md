# Kubernetes Experimental Environment

This directory contains scripts and configuration files to create a complete experimental environment for Kubernetes in a [VMware vSphere](https://docs.vmware.com/de/VMware-vSphere/index.html) environment. Using [Packer](https://www.packer.io/), [Ubuntu 22.04](https://releases.ubuntu.com/jammy/) templates are created, which are then used together with [Terraform](https://www.terraform.io/) and [Ansible](https://www.ansible.com/) to set up various Kubernetes clusters and distributions.
In the course of our research, we employed four Kubernetes distributions as test scenarios.


## Kubernetes Distributions Used as Test Scenarios

Kubernetes distributions represent a modified variant of the official version of Kubernetes, the so-called "Vanilla Kubernetes"  [[Glu23](https://romanglushach.medium.com/vanilla-vs-distribution-kubernetes-understanding-the-differences-c1f0144ff099); [Jha21](https://www.digitalocean.com/blog/vanilla-kubernetes-vs-managed-kubernetes)].
Often a manufacturer combines its own functions, tools, or technologies with Kubernetes and thus creates its own distribution [[Glu23](https://romanglushach.medium.com/vanilla-vs-distribution-kubernetes-understanding-the-differences-c1f0144ff099); [Jha21](https://www.digitalocean.com/blog/vanilla-kubernetes-vs-managed-kubernetes); [Len19](https://www.suse.com/c/what-is-a-kubernetes-distribution-and-why-would-you-want-one/)].
However, for comparability reasons, only the core components of the respective Kubernetes distributions described in Table 1 are considered, while all additional vendor-specific technologies and features are excluded from further analysis.
Specifically, the distributions are distinguished regarding the container runtime, the key value store, the network plugin, and the implementation of the Kubernetes components used, collectively referred to as the *Kubernetes engine* [[SUS24d](https://docs.rke2.io/); [Glu23](https://romanglushach.medium.com/vanilla-vs-distribution-kubernetes-understanding-the-differences-c1f0144ff099)].

This research does not consider cloud-based Kubernetes distributions, as they are not suitable for use in a dedicated experimental environment due to their proprietary nature and limited analysis capabilities [[SCP21](https://ieeexplore.ieee.org/document/9557787), p.4].
Specifically, the "Elastic Kubernetes Service" (EKS) [[Ama23b](https://aws.amazon.com/de/eks/)] from Amazon, "Azure Kubernetes Service" (AKS) [[Mic23a](https://learn.microsoft.com/en-us/azure/aks/)] from Microsoft, and "Google Kubernetes Engine" (GKE) [[Goo24b](https://cloud.google.com/kubernetes-engine)] are not further considered.
Instead, only Kubernetes distributions in which at least parts of the distribution are publicly available are examined.
Therefore, in addition to the widely used distributions "Red Hat OpenShift" [[Red22c](https://www.redhat.com/rhdc/managed-files/cl-state-of-kubernetes-security-report-2022-ebook-f31209-202205-en.pdf)] by Red Hat, Inc. and "Rancher" [[SUS24d](https://docs.rke2.io/)] by SUSE, the original version of Kubernetes is also examined [[Red22c](https://www.redhat.com/rhdc/managed-files/cl-state-of-kubernetes-security-report-2022-ebook-f31209-202205-en.pdf); [Red23a](https://access.redhat.com/solutions/5459051); [SUS24d](https://docs.rke2.io/)].
The latter is included because, according to an empirical survey by Red Hat, Inc., self-managed Kubernetes systems are widely used alongside Red Hat OpenShift and Rancher, although their exact structure is not specified [[Red22c](https://www.redhat.com/rhdc/managed-files/cl-state-of-kubernetes-security-report-2022-ebook-f31209-202205-en.pdf)].
However, since most known Kubernetes distributions are listed in the survey, it can be assumed that some of these self-managed Kubernetes systems are implemented using the official *kubeadm* installation tool and are therefore based on the original version of Kubernetes without further modifications by third parties [[The23n](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/); [Til23a](https://humalect.com/blog/kubernetes-statistics); [Clo23a](https://www.cncf.io/reports/cncf-annual-survey-2022/)].
For this reason, in addition to the aforementioned Kubernetes distributions, the original version of Kubernetes, in combination with the container runtime *containerd* and the network plugin *Weave*, is also examined.
The latter is one of the most widely used network plugins, as measured by the stars of the respective GitHub projects, alongside the already examined plugins Cilium and Flannel [[Pro24](https://github.com/projectcalico/calico); [The24a](https://github.com/cilium/cilium); [Fla24](https://github.com/flannel-io/flannel); [Wea24](https://github.com/weaveworks/weave)].

Furthermore, the open-source Kubernetes distribution "K3s" [[K3s24b](https://docs.k3s.io/)] is considered, as its lightweight nature requires minimal configuration effort during installation and is specifically designed for use in resource-constrained environments such as IoT.
This considerably reduces the threshold for utilization of the Kubernetes distribution [[Til23b](https://humalect.com/blog/kubernetes-distributions); [K3s24b](https://docs.k3s.io/)].
As a result, K3s is used in many public guides and some other experimental environments, indicating that this distribution is frequently deployed in use cases where the use of a costly proprietary distribution is not justified [[Til23b](https://humalect.com/blog/kubernetes-distributions); [Kum23](https://www.devopsschool.com/blog/a-basic-k3s-tutorial-for-kubernetes/); [Tec23](https://technotim.live/posts/low-power-cluster/)].
Therefore, K3s is examined as a representative of lightweight and beginner-friendly distributions in this research.
Additionally, by closely examining Rancher and Red Hat OpenShift, distributions with a focus on the enterprise context are analysed, which represent significantly more complex Kubernetes distributions [[Red24e](https://www.redhat.com/en/technologies/cloud-computing/openshift)].
Both include a wide range of features that can be used, among other things, in the lifecycle of containerized applications or to better secure the cluster [[Red23c](https://www.redhat.com/en/resources/self-managed-openshift-sizing-subscription-guide); [SUS24d](https://docs.rke2.io/)].
For example, Red Hat OpenShift also provides a container registry and an integrated "Identity Provider" (IdP) [[Clo24b](https://www.cloudflare.com/learning/access-management/what-is-an-identity-provider/)], but an investigation of these would exceed the scope of this research [[Clo24b](https://www.cloudflare.com/learning/access-management/what-is-an-identity-provider/); [Red23c](https://www.redhat.com/en/resources/self-managed-openshift-sizing-subscription-guide)].
Rancher also offers additional features, such as native cluster hardening following the current CIS benchmark of the "Center for Internet Security" (CIS) [[Cen24](https://www.cisecurity.org/cis-benchmarks/); [SUS24c](https://docs.rke2.io/security/hardening_guide)].
This function was enabled in the experimental environment to realistically represent the security level of this distribution.

It should also be noted that, as shown in Table 1, the Kubernetes engine and the network plugin of OpenShift have been replaced by fully open-source alternatives, as the source code of these components is publicly available, but parts of the associated documentation are not freely accessible, as shown in [[Red23a](https://access.redhat.com/solutions/5459051)].
Additionally, unlike other distributions, Red Hat OpenShift only allows a limited selection of Kubernetes components and possible extensions [[Red24c](https://catalog.redhat.com/software/search?p=1); [The21a](https://cilium.io/blog/2021/04/19/openshift-certification/)].
Therefore, in the experimental environment, a scenario based on Red Hat OpenShift was implemented using kubeadm and "Calico" [[Tig24b](https://www.tigera.io/project-calico/)] as the network plugin, which approximates the distribution as closely as possible but does not implement it natively.

In addition to the Kubernetes distributions examined here, there are a number of other notable distributions that are also used by many organizations [[Red22c](https://www.redhat.com/rhdc/managed-files/cl-state-of-kubernetes-security-report-2022-ebook-f31209-202205-en.pdf)].
These include "VMware Tanzu" [[Red22c](https://www.redhat.com/rhdc/managed-files/cl-state-of-kubernetes-security-report-2022-ebook-f31209-202205-en.pdf)] and the Kubernetes platform from Kubermatic [[Kub24d](https://www.kubermatic.com/products/kubermatic-kubernetes-platform/)].
However, due to capacity constraints, only the most widely used distributions are considered here, so a comprehensive examination of all Kubernetes distributions used in practice must take place in future research.



##### Table 1: Components of the included Kubernetes distributions
|                          | **Kubernetes engine** | **key value store** | **network plugin** | **container runtime** |
|-------------------------|-----------------------|-------------------|--------------------|-----------------------|
| **Vanilla Kubernetes**   | Kubernetes [[The23m](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)]   | etcd [[The23m](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)]     | Weave [[Wea24](https://github.com/weaveworks/weave)]      | containerd [[Red22a](https://www.redhat.com/rhdc/managed-files/cl-state-of-kubernetes-security-report-2022-ebook-f31209-202205-en.pdf)]   |
| **Rancher**              | RKE2 [[SUS24d](https://docs.rke2.io/)]         | etcd [[SUS24b](https://docs.rke2.io/architecture)]     | Cilium [[SUS24e](https://docs.rke2.io/install/network_options)]    | containerd [[SUS24d](https://docs.rke2.io/)]   |
| **K3s**                  | K3s [[K3s24b](https://docs.k3s.io/)]          | SQLite [[K3s24a](https://docs.k3s.io/datastore)]   | Flannel [[K3s24b](https://docs.k3s.io/)]   | containerd [[K3s24b](https://docs.k3s.io/)]   |
| **Red Hat OpenShift**    | Kubernetes (replacement for OpenShift Kubernetes Engine) [[Red23a](https://access.redhat.com/solutions/5459051)]  | etcd [[Red24d](https://docs.openshift.com/container-platform/4.14/installing/index.html)]     | Calico (replacement for OpenShift SDN) [[Red24b](https://docs.openshift.com/container-platform/4.14/networking/openshift_sdn/about-openshift-sdn.html)]   | CRI-O [[Red24d](https://docs.openshift.com/container-platform/4.14/installing/index.html)]        |


## Architecture of the Experimental Environment

All four test scenarios and their respective clusters are implemented with three worker and master nodes based on [Ubuntu 22.04 LTS](https://releases.ubuntu.com/jammy/).
However, in the case of the test scenario for K3s, only one master node is used, as a highly available configuration of this distribution with the native key value store "SQLite" [[K3s24a](https://docs.k3s.io/datastore)] is not feasible and the distribution is optimized for resource-constrained application areas [[K3s24b](https://docs.k3s.io/)].
Essentially, the experimental environment is implemented based on the "Infrastructure as Code" (IaC) [[Red22b](https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac)] concept, which allows the four considered test scenarios to be fully automated after a one-time configuration, enabling them to be set up and torn down automatically.
This makes it possible to assess the measures independently and thus avoid the interactions of several measures in this work.
Specifically, the experimental environment is implemented using [Terraform](https://www.terraform.io/), [Packer](https://www.packer.io/), and [Ansible](https://www.ansible.com/) on a [VMware vSphere](https://docs.vmware.com/de/VMware-vSphere/index.html) server.

To simulate a typical cryptojacking incident, a web server, an additional ServiceAccount with administrative rights, and a tool for cryptocurrency mining (Cryptominer) are integrated within the four test scenarios, which can be used later to demonstrate individual measures.
Although the full-fledged Cryptominer "Xmrig" [[KH23](https://www.igi-global.com/gateway/chapter/315968)] is used, an ethical configuration is chosen to ensure that no cryptocurrency is generated.
A comprehensive overview of the experimental setup is provided in Figure 1.
The source code required to replicate the environment is available in this repository.

##### Figure 1: Architecture of the experimental environment

![Architecture of the experimental environment](../graphics/architecture.drawio.png)



## Prerequisites

To set up the Kubernetes experimental environment, the following tools need to be installed in a UNIX environment:

- [Packer](https://www.packer.io/downloads)
- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Git](https://git-scm.com/)

Additionally, an installation file (ISO) for Ubuntu 22.04 and administrative access to a VMware vSphere server are required. This server is used as the basis for provisioning the necessary infrastructure. More information on obtaining an evaluation licence can be found [here](https://customerconnect.vmware.com/en/evalcenter?p=vsphere-eval-8).

## Usage

1. First, download the experimental environment on a system that has a network connection to the vSphere server:

    ```bash
    $ git clone <link>
    ```

2. Next, configure all necessary variables for Packer. You can use the template [`example.pkrvars.hcl`](Packer/Ubuntu_22_04/example.pkrvars.hcl) located in `Packer/Ubuntu_22_04/` and adjust it:

    ```bash
    $ cp example.pkrvars.hcl custom.auto.pkrvars.hcl
    $ nano custom.auto.pkrvars.hcl
    ```

    A detailed documentation of the variables can be found in the file [`variables.pkr.hcl`](Packer/Ubuntu_22_04/variables.pkr.hcl). Current installation files for Ubuntu 22.04 can be downloaded from the [official Ubuntu website](https://ubuntu.com/download/server). Further information on configuring the vSphere server and the required variables can be found in the [VMware vSphere Builder documentation](https://developer.hashicorp.com/packer/integrations/hashicorp/vsphere/latest/components/builder/vsphere-iso).

3. Then, the Ubuntu template can be created using Packer. Depending on the available hardware resources, this process may take several minutes to hours:

    ```bash
    $ cd ./Packer/Ubuntu_22_04/
    $ packer init .
    $ bash build.sh
    ```

4. While the Ubuntu template is being created, you can configure the necessary Terraform settings. Use the file [`example.tfvars`](Terraform/example.tfvars) located in the `Terraform/` directory as a base and adjust it:

    ```bash
    $ cp example.tfvars variables.auto.tfvars
    $ nano variables.auto.tfvars
    ```

    A detailed documentation of the variables can be found in the file [`variables.tf`](Terraform/variables.tf). Further information on configuring the vSphere server and the required variables can be found in the [Terraform Provider for VMware vSphere documentation](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs).

5. After configuring Terraform and completing the Ubuntu template, the Kubernetes experimental environment can be created:

    ```bash
    $ cd ./Terraform
    $ terraform init
    $ bash all_apply.sh
    ```

6. Once the environment is set up, the individual Kubernetes clusters can be used. The necessary Kubernetes configuration files (Kubeconfig) for each test scenario can be found in [`kubeconfigs/`](kubeconfigs/). Alternatively, the following command can be executed in the `Terraform` directory to use the configuration for the current test scenario:

    ```bash
    $ export KUBECONFIG=../kubeconfigs/$(terraform workspace show)/kubeconfig
    ```

7. The following sample applications are automatically deployed in each cluster:

    - Kubernetes Dashboard:
      - `https://<Node-IP>:30443`
      - To retrieve the login token:
        ```bash
        kubectl -n kubernetes-dashboard create token admin-user
        ```
    - Nginx Web Server:
      -  `http://<Node-IP>:30007`
    - Cryptominer Xmrig

8. If necessary, the Kubernetes clusters can be recreated with the following commands:

    ```bash
    $ cd ./Terraform/
    $ bash recreate_clusters.sh
    ```

9. To completely remove the experimental environment, the following commands can be used:

    ```bash
    $ cd ./Terraform/
    $ bash all_destroy.sh
    ```

## Directory Structure

- [`Packer/`](Packer/): Contains all Packer configuration files for creating Ubuntu 22.04 templates.
- [`Terraform/`](Terraform/): Contains all Terraform configuration files for the Kubernetes experimental environment.
- [`Ansible/`](Ansible/): Contains all files for configuring the Kubernetes experimental environment.
- [`kubeconfigs/`](kubeconfigs/): Contains all kubeconfig files.

## Notes

- The experimental environment is intended for testing purposes and is not supported long-term. It should not be used in production environments without further adjustments.
- The source code was developed and published as part of a research project.
- The following repositories were referenced during the creation of the source code:
  - https://github.com/vmware-samples/packer-examples-for-vsphere
  - https://github.com/kairen/kubeadm-ansible
  - https://github.com/githubixx/ansible-role-cilium-cli/tree/master

## Limitations

- Only Kubernetes versions `v1.24.1` to `v1.28.5` are supported.
- The use of etcd with K3s is not supported.
- The use of CRI-O as a container runtime for K3s is not possible.
- Only the Flannel network plugin can be used with K3s.
- Due to the use of SQLite, K3s can only be used with a single master node.
- The following versions of network plugins are supported:
  - Cilium: v1.14.4
  - Calico: v3.26.3
  - Canal: v3.26.3
  - Flannel: v0.23.0
