#!/bin/bash

echo $1 > /sys/class/fe_AD1939_*/fe_AD1939_*/dac1_left_volume
echo $1 > /sys/class/fe_AD1939_*/fe_AD1939_*/dac1_right_volume
