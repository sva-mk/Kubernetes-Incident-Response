# Responding to Cryptojacking Attacks on Kubernetes Using an Incident Response Playbook

This repository contains all the materials, data, and source code related to the research paper, entitled "Responding to Cryptojacking Attacks on Kubernetes Using an Incident Response Playbook".
In addition, it comprises a comprehensive presentation of the research findings and the methodology employed.
These include a detailed description of the developed playbook, including the associated source code for further use in the modeling platform [SecMoF](https://github.com/CardiffUniCOMSC/SecMoF), and a detailed presentation of all identified measures.
Alongside this, the evaluation of each individual measure is described in detail and evidence of implementation is provided.


## Repository Structure

### Response Measure Collection
All information associated with the response measure collection is stored in the `measures` directory and its respective subdirectories.
This encompasses a comprehensive description of each measure, accompanied by a detailed explication of the evaluation results.
Moreover, the evidence produced during the evaluation of the measures is presented.


### Incident Response Playbook
The incident response playbook for cryptojacking attacks on Kubernetes, developed as part of the research, is accessible via the `playbook` directory.
Additionally, the respective directory contains instructions on how to configure and use the playbook within the modeling platform [SecMoF](https://github.com/CardiffUniCOMSC/SecMoF).
Moreover, this comprises a comprehensive account of the dependency model employed in conjunction with the playbook, accompanied by a concise overview of the FRIPP approach and its visual representation.

### Experimental Environment
The source code of the experimental environment, which is used to facilitate the implementation of the four test scenarios designed for the evaluation of each measure, is provided in the `environment` directory.
Furthermore, the directory contains a comprehensive description of the configuration employed for the four test scenarios, as well as a concise justification for the selection of these specific four local Kubernetes distributions for the evaluation of the aforementioned measure collection.

### Graphics
The ``graphics` directory contains graphics used in this repository.

## Notes
- It is recommended that all the included materials, data, and source code be further improved before practical application, given that they were developed as part of scientific research. In particular, the measure collection and incident response playbook included in this repository require further improvement, as they are not yet fully mature. This entails evaluating them in a broader manner as well as in a more comprehensive environment and incorporating additional measures. Furthermore, the playbook, as well as the underlying FRIPP approach, should be improved in the future, in order to facilitate a structured and efficient response to cryptojacking attacks targeting Kubernetes.
- It should be noted that the experimental environment included in this repository is intended for testing purposes only and is not supported long-term. It should not be used in production environments without further adjustments, as it has a number of limitations described in the respective directory.
- Similarly, it should be noted that the four test scenarios of the experimental environment do not seek to provide a comprehensive representation of all existing Kubernetes distributions. Instead, they offer a streamlined representation of the most commonly used local Kubernetes distributions.  Moreover, the source code of the experimental environment can be expanded to incorporate additional scenarios and employ them to recreate the evaluation based on a more extensive set of test scenarios.
