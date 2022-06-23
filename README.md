# Oracle

For the purpose of IBM Data Replicaiton test below is the complete guidance to step-by-step operations to prepare clean environment with fresh deployment of container based Oracle deployment, xStream Out server, IIDR agent, followed by configruation and test of the subscription for tracking data changes on Oracle with replication to Kafka.

Access Server, Kafka and management console have been previously deployed, tested and configured within another repository IBM-IIDR-deployment also publically available here: https://github.com/Polosatis/IBM-IIDR-deployment

This repository contains scripts which have been run in personal virtualized environment (laptop based VMWare Workstation) in the following sequence:

01. Deployment of Oracle 19c on RHEL
02. Oracle post-install best practices
03. Prepare sample data for IIDR test
04. Configure Oracle xStream
05. Install Oracle xStream agent
