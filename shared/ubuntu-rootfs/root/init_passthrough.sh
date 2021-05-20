#!/bin/bash
scriptdir=/root/passthrough_scripts
homedir=/root

insmod $homedir/FE_AD1939.ko
insmod $homedir/FE_TPA613A2.ko

# Set the codec sample frequency
$scriptdir/changefs.sh 48

# Set the DAC volume
$scriptdir/changedac1volume.sh 0.0
$scriptdir/changedac2volume.sh 0.0
$scriptdir/changedac3volume.sh 0.0
$scriptdir/changedac4volume.sh 0.0

# Set the headphone amp volume
$scriptdir/changeampvolume.sh 0.0
