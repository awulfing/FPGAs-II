#!/bin/bash

fs=$(cat /sys/class/fe_AD1939_*/fe_AD1939_*/sample_frequency)

echo The sampling frequency is $fs kHz
