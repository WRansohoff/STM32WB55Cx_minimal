/*
 * Minimal RCC (Reset & Clock Control) interface methods.
 */
#ifndef __VVC_RCC
#define __VVC_RCC

// Device header file.
#include "stm32wbxx.h"

// Extern values which must be defined in the application source.
extern uint32_t core_clock_hz;
extern volatile uint32_t systick;

// Millisecond delay method.
void delay_ms( uint32_t ms );

// Placeholder method to set the core clock speed to 64MHz.
void clock_setup( void );

#endif
