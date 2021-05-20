#!/bin/bash
vol_left=/sys/devices/platform/ff200000.ring/left_Volume
vol_right=/sys/devices/platform/ff200000.ring/right_Volume
ena_left=/sys/devices/platform/ff200000.ring/left_enable
ena_right=/sys/devices/platform/ff200000.ring/right_enable
echo 1 > $ena_left
echo 1 > $ena_right
echo 1 > $vol_left
echo 1 > $vol_right

