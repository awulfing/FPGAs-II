#!/bin/bash

dl=$(cat /sys/class/fe_AD1939_*/fe_AD1939_*/dac3_left_volume)
dr=$(cat /sys/class/fe_AD1939_*/fe_AD1939_*/dac3_right_volume)

echo The left volume is $dl dB
echo The right volume is $dr dB
