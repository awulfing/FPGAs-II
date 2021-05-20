#!/bin/bash

echo $1 > /sys/class/fe_AD1939_*/fe_AD1939_*/dac4_left_volume
echo $1 > /sys/class/fe_AD1939_*/fe_AD1939_*/dac4_right_volume
