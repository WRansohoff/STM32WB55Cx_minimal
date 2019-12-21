#ifndef _VVC_GLOBAL_H
#define _VVC_GLOBAL_H

// Standard library includes.
#include <stdint.h>
#include <string.h>

// Device header file includes.
#include "stm32wbxx.h"

// Port / HAL / BSP includes.
#include "rcc.h"
#include "usb.h"

// Global defines.
// (LED pin depends on your board)
#if defined( STM32WB55CEU6 )
  #define PoLED   ( GPIOE )
  #define PiLED   ( 4 )
#endif

// Global variables.
uint32_t core_clock_hz;
volatile uint32_t systick;

#endif
