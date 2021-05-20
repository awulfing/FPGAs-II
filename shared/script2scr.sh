#!/bin/bash
mkimage -A arm -O u-boot -T script -C none -a 0 -e 0 -n "TFTP U-Boot Script" -d u-boot_passthrough.script u-boot_passthrough.scr
