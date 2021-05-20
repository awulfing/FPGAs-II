ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
obj-m := hello.o

else
# normal makefile

# path to kernal directory
KDIR ?= /lib/modules/`uname -r`/build

default:
	$(MAKE) -C $(KDIR) M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif
