=================================================================
zabbix_agentd SMF Installation & Remove (C) 2007-2025 Yuri Voinov
=================================================================

***  ATTENTION!  The  package  is  configured  by  default to run
zabbix_agentd installed in /usr/local!

This  set  of  scripts  is designed to install and remove the SMF
service for zabbix_agentd on Sun Solaris 10 and higher.

All  necessary  prerequisites  required  to run the zabbix_agentd
service,   according   to   the  configuration  guide  (excluding
zabbix_agentd  configuration  itself)  are  performed  during the
service  installation  process,  deleting the SMF service deletes
all  scripts  and unregisters the zabbix_agentd service and stops
it.

For  the  service  to  work,  a  default  user  and group must be
created:

groupadd zabbix
useradd -g zabbix -d /usr/local/sbin -s /bin/sh -c "Zabbix Monitoring System" zabbix
passwd -N zabbix


To enable zabbix_agentd SMF, follow these steps:
------------------------------------------------------------

1.  Install  zabbix_agentd  and  all  necessary libraries, if not
already done.

2. Configure zabbix_agentd by editing zabbix_agentd.conf.

3.  Run  the zabbix_agentd_smf_inst.sh script, which will perform
all  necessary  prerequisites  and  post-installation actions and
install the zabbix_agentd SMF service.

4.  Run  the  svcadm enable zabbix_agentd command to activate and
start the zabbix_agentd service.

To  deactivate and remove zabbix_agentd SMF service, follow these
-----------------------------------------------------------------
steps:
------

1.Run  the  zabbix_agentd_smf_rmv.sh script. The script stops all
running  zabbix_agentd  processes,  unregisters  the SMF service,
completely   removes   zabbix_agentd   SMF  and  rolls  back  the
operations performed earlier when activating the service.

***  Note: Removing the zabbix_agentd SMF service does not remove
the installed zabbix_agentd software, user, and group.

To delete a user and group, run:

userdel zabbix
groupdel zabbix

Archive contains:

init.unbound        - zabbix_agentd SMF control method
unbound.xml         - zabbix_agentd SMF Service Manifest
readme_ru.txt         - Этот файл (Russian)
readme_en.txt         - This file (English)
unbound_smf_inst.sh    - zabbix_agentd SMF installation script
unbound_smf_rmv.sh     - Script for deleting zabbix_agentd SMF

=================================================================
zabbix_agentd SMF Installation & Remove (C) 2007-2025 Yuri Voinov
=================================================================
