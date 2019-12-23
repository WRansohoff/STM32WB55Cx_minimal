/*
 * Minimal USB interface methods.
 */
#include "usb.h"

// Global USB buffer table reference. This array should account for
// 64 bytes, so all USB PMA addresses must be >= 0x40.
usb_ep_buf* btable = ( usb_ep_buf* )( 0x40006000 );

// Initialize the USB peripheral for acting as a virtual serial port.
void usb_init_vsp( usb_vsp* vsp ) {
  // Disable all USB interrupts in the USB peripheral.
  uint32_t usb_irq_flags = ( USB_CNTR_CTRM |
                             USB_CNTR_WKUPM |
                             USB_CNTR_SUSPM |
                             USB_CNTR_ERRM |
                             USB_CNTR_SOFM |
                             USB_CNTR_ESOFM |
                             USB_CNTR_RESETM |
                             USB_CNTR_L1REQM );
  USB->CNTR &= ~( usb_irq_flags );
  // Enable the 'low-priority' USB interrupt with a high priority.
  NVIC_SetPriority( USB_LP_IRQn,
                    NVIC_EncodePriority( 0x00, 0x01, 0x00 ) );
  NVIC_EnableIRQ( USB_LP_IRQn );

  // Force a USB reset by toggling the `FRES` bit.
  USB->CNTR   |=  ( USB_CNTR_FRES );
  USB->CNTR   &= ~( USB_CNTR_FRES );
  // Exit power-down mode.
  USB->CNTR   &= ~( USB_CNTR_PDWN );
  // Clear all pending USB interrupts.
  USB->ISTR    =  ( 0 );
  // Set BTABLE address to a PMA offset of 0.
  USB->BTABLE &= ~( USB_BTABLE_BTABLE );
  // Enable USB peripheral interrupts.
  USB->CNTR   |=  ( usb_irq_flags );

  // Setup PMA addresses. Note: this writes directly to PMA memory.
  // Endpoint 0 is always a bi-directional 'device control' endpoint.
  // (MSbit of endpoint address determines R/W; 0 = out, 1 = in)
  // The buffer table can take up to 64 bytes (8 bytes * 8 endpoints),
  // so start at PMA address 0x40. Allow 64 bytes per control buffer.
  btable[ 0 ].tx_addr = 0x0040;
  btable[ 0 ].tx_cnt  = 0x0000;
  btable[ 0 ].rx_addr = 0x0080;
  btable[ 0 ].rx_cnt  = 0x8001;
  // Endpoint 1 should be used for CDC communication, as the virtual
  // serial port. So again, use a bi-directional channel. Allow
  // 64 bytes per VSP buffer as well.
  btable[ 1 ].tx_addr = 0x00C0;
  btable[ 0 ].tx_cnt  = 0x0000;
  btable[ 0 ].rx_addr = 0x0100;
  btable[ 0 ].rx_cnt  = 0x8001;

  // Enable the D+ pull-up resistor.
  USB->BCDR   |=  ( USB_BCDR_DPPU );
}

// USB high-priority interrupt.
void USB_HP_IRQ_handler( void ) {
  // TODO
}

// USB low-priority interrupt.
void USB_LP_IRQ_handler( void ) {
  // TODO
}
