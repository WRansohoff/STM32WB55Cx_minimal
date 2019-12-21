# Overview

Test 'virtual COM port' application, which uses the USB peripheral to set up a virtual serial connection similar to plugging a USB/UART converter into one of the chip's UART peripherals.

I would like to use the example in ST's `STM32Cube` firmware package to test my STM32WB55 USB dongles' 2.4GHz radios, but when I try to use the `BLE_TransparentModeVCP` project with any hardware (including the official 'Nucleo' USB dongle), it fails to enumerate as a USB device on both Windows 10 and Linux machines. It encounters the same error in both cases ('device fails to respond to published address'), and neigher the 'old' nor 'new' style `usbcore` enumerations work on Linux. I started trying to debug the issue and discovered that, at least with STM32 chips, these errors are often caused when a firmware fails to disable the USB peripheral's "VBUS sensing" option. But digging through the endlessly-nesting STM32Cube example code is *way* too tedious and annoying for a fun hobby project. I'm just not going to do it.

I've been meaning to learn about the STM32 USB peripheral anyways though, so I see this as an opportunity rather than a problem. And in fairness to ST, their `BLE_TransparentMode` project for the 'Nucleo' mainboard works very well; the `ST-Link` VCP functionality is excellent. Sadly, the implementation that they use in v1.3 of the STM32WB Cube package does not seem to work, even with their own hardware.

NB: this is a fairly new product line and these sorts of difficulties are not unique to ST, whose products I generally like and admire. But as with most other embedded products, you can't expect things to work "out-of-the-box", and you can't expect technical support unless you make large ongoing purchases directly from the company. C'est la vie! `¯\_(ツ)_/¯`

# Current Status

Currently, this test firmware is a non-functional work-in-progress.
