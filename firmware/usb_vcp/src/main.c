#include "main.h"

/**
 * Reset handler: copy .data section and clear .bss section
 * before jumping to the main loop.
 */
__attribute__( ( naked ) ) void reset_handler( void ) {
  // Set the stack pointer to the 'end of stack' value.
  __asm__( "LDR r0, =_estack\n\t"
           "MOV sp, r0" );
  // Branch to main.
  __asm__( "B main" );
}

/**
 * Main program.
 */
int main( void ) {
  // Copy initialized data from .sidata (Flash) to .data (RAM)
  memcpy( &_sdata, &_sidata, ( ( void* )&_edata - ( void* )&_sdata ) );
  // Clear the .bss section in RAM.
  memset( &_sbss, 0x00, ( ( void* )&_ebss - ( void* )&_sbss ) );

  // Enable GPIOA/B/C/E, USB, CRS peripherals.
  RCC->AHB2ENR   |= ( RCC_AHB2ENR_GPIOAEN |
                      RCC_AHB2ENR_GPIOBEN |
                      RCC_AHB2ENR_GPIOCEN |
                      RCC_AHB2ENR_GPIOEEN );
  RCC->APB1ENR1  |= ( RCC_APB1ENR1_CRSEN |
                      RCC_APB1ENR1_USBEN );

  // Setup the NVIC hardware interrupts.
  // Use 4 bits for 'priority' and 0 bits for 'subpriority'.
  NVIC_SetPriorityGrouping( 0x00 );

  // Initial clock setup.
  clock_setup();

  // Output type: Push-pull, low-speed.
  PoLED->MODER    &= ~(0x3 << (PiLED * 2));
  PoLED->MODER    |=  (0x1 << (PiLED * 2));
  PoLED->OTYPER   &= ~(0x1 << PiLED);
  PoLED->OSPEEDR  &= ~(0x3 << (PiLED * 2));
  PoLED->OSPEEDR  |=  (0x1 << (PiLED * 2));
  PoLED->ODR      |=  (1 << PiLED);

  // Toggle the LED every second.
  while (1) {
    delay_ms( 1000 );
    PoLED->ODR ^=  (1 << PiLED);
  }
}
