/*
 * Minimal RCC (Reset & Clock Control) interface methods.
 */
#include "rcc.h"

// Delay for a specified number of milliseconds.
// TODO: Prevent rollover bug on the 'systick' value.
void delay_ms( uint32_t ms ) {
  // Calculate the tick value when the system should stop delaying.
  uint32_t next = systick + ms;

  // Wait until the system reaches that tick value.
  // Use the 'wait for interrupt' instruction to save power.
  while ( systick < next ) { __asm__( "WFI" ); }
}

// Placeholder method to set the core clock speed to 64MHz.
void clock_setup( void ) {
  // Flash settings:
  // * Set 3 wait states (use 4 instead if operating at 1.8V)
  // * (Data cache and instruction cache are enabled by default).
  // * Enable prefetching.
  FLASH->ACR &= ~( FLASH_ACR_LATENCY );
  FLASH->ACR |=  ( ( 0x3 << FLASH_ACR_LATENCY_Pos ) |
                   FLASH_ACR_PRFTEN );
  // Enable HSI16 and HSI48 oscillators.
  // TODO: It's lazy to use the internal 48MHz oscillator,
  // when the PLLSAI1 clock can also be used.
  RCC->CR    |=  ( RCC_CR_HSION );
  RCC->CRRCR |=  ( RCC_CRRCR_HSI48ON );
  // PLL configuration: frequency = ( 16MHz * ( N / M ) ) / R
  // For 64MHz, R = 2, M = 1, N = 8.
  RCC->PLLCFGR &= ~( RCC_PLLCFGR_PLLN |
                     RCC_PLLCFGR_PLLM |
                     RCC_PLLCFGR_PLLR |
                     RCC_PLLCFGR_PLLREN |
                     RCC_PLLCFGR_PLLPEN |
                     RCC_PLLCFGR_PLLQEN |
                     RCC_PLLCFGR_PLLSRC );
  RCC->PLLCFGR |=  ( RCC_PLLCFGR_PLLREN |
                     8 << RCC_PLLCFGR_PLLN_Pos |
                     2  << RCC_PLLCFGR_PLLSRC_Pos );
  // Wait for the HSI oscillator to be ready.
  while ( !( RCC->CR & RCC_CR_HSIRDY ) ) {};
  // Enable the PLL and select it as the system clock source.
  RCC->CR   |=  ( RCC_CR_PLLON );
  while ( !( RCC->CR & RCC_CR_PLLRDY ) ) {};
  RCC->CFGR &= ~( RCC_CFGR_SW );
  RCC->CFGR |=  ( 0x3 << RCC_CFGR_SW_Pos );
  while ( ( RCC->CFGR & RCC_CFGR_SWS ) != ( 0x3 << RCC_CFGR_SWS_Pos ) ) {};
  // System clock is now 64MHz.
  core_clock_hz = 64000000;
  // Disable the MSI oscillator, since it is no longer being used.
  RCC->CR   &= ~( RCC_CR_MSION );

  // 48MHz USB clock source setup.
  // TODO: Prevent CPU2 from disabling HSI48?
  // Wait for the 48MHz oscillator to be ready. (Enabled above^)
  while ( !( RCC->CRRCR & RCC_CRRCR_HSI48RDY ) ) {};
  // Ensure that the HSI48 oscillator is driving the 48MHz clock.
  // This drives the USB and TRNG peripherals by default.
  RCC->CCIPR &= ~( RCC_CCIPR_CLK48SEL );

  // Reset clock recovery system.
  RCC->APB1RSTR1 |=  ( RCC_APB1RSTR1_CRSRST );
  RCC->APB1RSTR1 &= ~( RCC_APB1RSTR1_CRSRST );
  // Set CRS prescaler to 1, sync source to USB start-of-frame signal.
  // Retain default post-reset error limit / counter reload values.
  CRS->CFGR      &= ~( CRS_CFGR_SYNCDIV |
                       CRS_CFGR_SYNCSRC );
  CRS->CFGR      |=  ( CRS_CFGR_SYNCSRC_1 );
  // Enable automatic trimming.
  // (Retain the default post-reset trimming value.)
  CRS->CR        |=  ( CRS_CR_AUTOTRIMEN |
                       CRS_CR_CEN );

  // Setup the SysTick peripheral to a 1ms tick rate.
  SysTick_Config( core_clock_hz / 1000 );
}

// SysTick interrupt handler. Right now, just increment the
// global 'systick' value.
void SysTick_handler( void ) {
  ++systick;
}
