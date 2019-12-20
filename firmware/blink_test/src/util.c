#include "util.h"

// Setup the core system clock speed.
void clock_setup(void) {
  // For testing, just use the default 4MHz MSI oscillator.
  core_clock_hz = 4000000;

  // Setup the SysTick peripheral to 1ms ticks.
  SysTick_Config( core_clock_hz / 1000 );
}

// Delay for a specified number of milliseconds.
// TODO: Prevent rollover bug on the 'systick' value.
void delay_ms( uint32_t ms ) {
  // Calculate the tick value when the system should stop delaying.
  uint32_t next = systick + ms;

  // Wait until the system reaches that tick value.
  // Use the 'wait for interrupt' instruction to save power.
  while ( systick < next ) { __asm__( "WFI" ); }
}

// SysTick interrupt handler. Right now, just increment the
// global 'systick' value.
void SysTick_handler( void ) {
  ++systick;
}
