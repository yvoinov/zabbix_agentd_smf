# Solaris Zabbix agent SMF
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://github.com/yvoinov/zabbix_agentd_smf/blob/main/LICENSE)

The service is designed for Solaris-based systems that do not have a Zabbix agent package or if the agent is compiled from sources.

The installation script copies the necessary elements of the service and creates the service itself in a disabled state.

The user and group, in case of building from sources, must be created manually (they are also not deleted when uninstalling the service or software):
```sh
groupadd zabbix
useradd -g zabbix -d /usr/local/sbin -s /bin/sh -c "Zabbix Monitoring System" zabbix
passwd -N zabbix
```
When deleting the service, Zabbix agent processes stops. The user and group are not deleted automatically and can be deleted manually:
```sh
userdel zabbix
groupdel zabbix
```
Follow these steps to enable Zabbix agent SMF:

1. Build (if nesessary) and install Zabbix agent if not already installed.

2. Adjust ahent configuration zabbix_agentd.conf as part of the package (placed to /usr/local/etc by default when building from sources).

3. Run the zabbix_agentd_smf_inst.sh script, which will perform all installation steps and install the Zabbix agent SMF service.

3. Run `svcadm enable zabbix_agentd` command to enable and start the Zabbix agent.

To deactivate and remove the Zabbix agent SMF service, follow these steps:

1. Run the zabbox_agentd_smf_rmv.sh  script. The script stops all running agent processes, unregisters the SMF service, completely removes the Zabbix agent SMF and rolls back the operations performed earlier when the service was activated.

Note: Removing the Zabbix agent SMF service does not remove the installed agent itself.
