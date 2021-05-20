#!/bin/bash

dl=$(cat /sys/class/fe_AD248/fe_AD1939_*/dac2_left_volume)
dr=$(cat /sys/class/fe_AD248/fe_AD1939_*/dac2_right_volume)

echo The left volume is $dl dB
echo The right volume is $dr dB
