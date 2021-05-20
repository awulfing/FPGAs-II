#!/bin/bash

vol=$(cat /sys/class/fe_TPA6130A2_*/fe_TPA6130A2_*/volume)

echo The headphone amplifier volume is $vol dB
