#!/bin/sh

#
# zabbix_agentd SMF remove.
# Yuri Voinov (C) 2007-2025
#
# ident "@(#)zabbix_agentd_smf_rmv.sh    2.5    05/04/25 YV"
#

#############
# Variables #
#############

PROGRAM_NAME="zabbix_agentd"
SERVICE_NAME="zabbix_agentd"
SCRIPT_NAME="init.""$SERVICE_NAME"
SMF_XML="$SERVICE_NAME"".xml"
SMF_DIR="/var/svc/manifest/network"
SVC_MTD="/lib/svc/method"

# OS utilities   
AWK=`which awk`
CUT=`which cut`
ECHO=`which echo`
GREP=`which grep`
ID=`which id`
PKILL=`which pkill`
PS=`which ps`
RM=`which rm`
SVCADM=`which svcadm`
SVCCFG=`which svccfg`
SVCS=`which svcs`
UNAME=`which uname`
ZONENAME=`which zonename`

OS_VER=`$UNAME -r|$CUT -f2 -d"."`
OS_NAME=`$UNAME -s|$CUT -f1 -d" "`
OS_FULL=`$UNAME -sr`
ZONE=`$ZONENAME`

###############
# Subroutines #
###############

os_check ()
{
 if [ "$OS_NAME" != "SunOS" ]; then
  $ECHO "ERROR: Unsupported OS $OS_NAME. Exiting..."
  exit 1
 elif [ "$OS_VER" -lt "10" ]; then
  $ECHO "ERROR: Unsupported $OS_NAME version $OS_VER. Exiting..."
  exit 1
 fi
}

root_check ()
{
 if [ ! `$ID | $CUT -f1 -d" "` = "uid=0(root)" ]; then
  $ECHO "ERROR: You must be super-user to run this script."
  exit 1
 fi
}

# Non-global zones notification
non_global_zones_r ()
{
if [ "$ZONE" != "global" ]; then
 $ECHO  "================================================================="
 $ECHO  "This is NON GLOBAL zone $ZONE. To complete uninstallation please remove"
 $ECHO  "script $SCRIPT_NAME"
 $ECHO  "from $SVC_MTD"
 $ECHO  "in GLOBAL zone manually AFTER uninstalling autostart."
 $ECHO  "================================================================="
fi
}

##############
# Main block #
##############

# Pre-inst checks
# OS version check
os_check

# Superuser check
root_check

$ECHO "------------------------------------------"
$ECHO "- $PROGRAM_NAME SMF service will be remove now   -"
$ECHO "-                                        -"
$ECHO "- Note:                                  -"
$ECHO "- Running $PROGRAM_NAME service will be stopped! -"
$ECHO "-                                        -"
$ECHO "- Press <Enter> to continue,             -"
$ECHO "- or <Ctrl+C> to cancel                  -"
$ECHO "------------------------------------------"
read p

# Disabling and stopping SMF service
$ECHO "Disabling and stopping running $PROGRAM_NAME service..."
$SVCADM disable $SERVICE_NAME>/dev/null 2>&1

# Remove SMF files
$ECHO "Remove $PROGRAM_NAME SMF files..."
if [ -f $SVC_MTD/$SCRIPT_NAME -a -f $SMF_DIR/$SMF_XML ]; then
 $RM -f $SVC_MTD/$SCRIPT_NAME

 $SVCCFG delete -f svc:/network/$SERVICE_NAME:default>/dev/null 2>&1
 $RM $SMF_DIR/$SMF_XML
else
 $ECHO "ERROR: $PROGRAM_NAME SMF service files not found. Exiting..."
 exit 1
fi

# Check for non-global zones uninstallation
non_global_zones_r

$ECHO "Verify $PROGRAM_NAME SMF uninstallation..."

# Check uninstallation
$SVCS $SERVICE_NAME>/dev/null 2>&1

retcode=`$ECHO $?`
case "$retcode" in
 0)
  $ECHO "*** $PROGRAM_NAME SMF service uninstallation process has errors"
  exit 1
 ;;
 *)
  $ECHO "*** $PROGRAM_NAME SMF service uninstallation successfuly"
 ;;
esac

exit 0
