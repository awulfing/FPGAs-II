#!/bin/bash

echo $1 > /sys/class/fe_AD1939_*/fe_AD1939_*/dac2_left_volume
echo $1 > /sys/class/fe_AD1939_*/fe_AD1939_*/dac2_right_volume
