/*
 * Minimal USB interface methods.
 */
#ifndef _VVC_WB_USB_H
#define _VVC_WB_USB_H

// Device header file.
#include "stm32wbxx.h"

// Port / HAL / BSP includes.
#include "ringbuf.h"

// Preprocessor definitions.
// Endpoint addresses.
#define USB_EPA_CTRL_R ( 0x0 )
#define USB_EPA_CTRL_W ( 0x8 )
#define USB_EPA_VSP_R  ( 0x1 )
#define USB_EPA_VSP_W  ( 0x9 )

typedef struct {
  uint16_t tx_addr;
  uint16_t tx_cnt;
  uint16_t rx_addr;
  uint16_t rx_cnt;
} usb_ep_buf;

extern usb_ep_buf* btable;

// Supporting struct to hold state for a USB virtual serial port.
typedef struct {
  ringbuf* tx_buf;
  ringbuf* rx_buf;
} usb_vsp;

/* TODO: HID device.
typedef struct {
} usb_hid;
*/

/* TODO: Mass storage device.
typedef struct {
} usb_ext;
*/

// Methods to initialize the chip as a USB device.
// Virtual serial port ("UART through USB")
void usb_init_vsp( usb_vsp* vsp );
// TODO: HID device (mouse/keyboard)
// TODO: Mass storage device (flash drive/hard drive)

// Methods to provide supporting functionality for a USB
// virtual serial port.
// Transmit bytes over the serial connection.
void usb_vsp_tx( uint8_t* bytes, uint16_t len );

#endif
