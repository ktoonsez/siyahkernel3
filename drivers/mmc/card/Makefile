#
# Makefile for MMC/SD card drivers
#
<<<<<<< HEAD
ifeq ($(CONFIG_TARGET_LOCALE_NTT),y)
=======
ifeq ($(CONFIG_MMC_CPRM),y)
>>>>>>> upstream/ics
EXTRA_CFLAGS += -I$(src)/cprm/softcprm
EXTRA_CFLAGS += -I$(src)/cprm/include
endif

obj-$(CONFIG_MMC_BLOCK)		+= mmc_block.o
mmc_block-objs			:= block.o queue.o
<<<<<<< HEAD
ifeq ($(CONFIG_TARGET_LOCALE_NTT),y)
=======
ifeq ($(CONFIG_MMC_CPRM),y)
>>>>>>> upstream/ics
mmc_block-objs			+= cprmdrv_samsung.o
endif
obj-$(CONFIG_MMC_TEST)		+= mmc_test.o

obj-$(CONFIG_SDIO_UART)		+= sdio_uart.o
