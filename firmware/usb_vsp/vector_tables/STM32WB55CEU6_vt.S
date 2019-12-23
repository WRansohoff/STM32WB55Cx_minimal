/*
 * Test program to boot an STM32 chip with the absolute
 * minimum required code for teaching about the chips.
 *
 * Open source under the MIT License
 */

.syntax unified
.cpu cortex-m4
.fpu softvfp /* TODO: Hardware fp */
.thumb

.global vtable
.global default_interrupt_handler

/*
 * The vector table.
 */
.type vtable, %object
.section .vector_table,"a",%progbits
vtable:
    .word _estack
    .word reset_handler
    .word NMI_handler
    .word hard_fault_handler
    .word mem_manage_handler
    .word bus_fault_handler
    .word usage_fault_handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_handler
    .word debug_monitor_handler
    .word 0
    .word pending_SV_handler
    .word SysTick_handler
    // 16-31
    .word window_watchdog_IRQ_handler
    .word PVD_PVM_IRQ_handler
    .word tamper_stamper_LSECSS_handler
    .word RTC_IRQ_handler
    .word flash_IRQ_handler
    .word RCC_IRQ_handler
    .word EXTI0_IRQ_handler
    .word EXTI1_IRQ_handler
    .word EXTI2_IRQ_handler
    .word EXTI3_IRQ_handler
    .word EXTI4_IRQ_handler
    .word DMA1_chan1_IRQ_handler
    .word DMA1_chan2_IRQ_handler
    .word DMA1_chan3_IRQ_handler
    .word DMA1_chan4_IRQ_handler
    .word DMA1_chan5_IRQ_handler
    .word DMA1_chan6_IRQ_handler
    .word DMA1_chan7_IRQ_handler
    .word ADC1_IRQ_handler
    .word USB_HP_IRQ_handler
    .word USB_LP_IRQ_handler
    .word C2SEV_PWR_C2H_IRQ_handler
    .word COMP_IRQ_handler
    .word EXTI9_5_IRQ_handler
    .word TIM1_break_IRQ_handler
    .word TIM1_up_TIM16_IRQ_handler
    .word TIM1_trig_COM_IRQ_handler
    .word TIM1_CC_IRQ_handler
    .word TIM2_IRQ_handler
    .word PKA_IRQ_handler
    .word I2C1_EV_IRQ_handler
    .word I2C1_ER_IRQ_handler
    .word I2C3_EV_IRQ_handler
    .word I2C3_ER_IRQ_handler
    .word SPI1_IRQ_handler
    .word SPI2_IRQ_handler
    .word USART1_IRQ_handler
    .word LPUART1_IRQ_handler
    .word SAI1_IRQ_handler
    .word TSC_IRQ_handler
    .word EXTI15_10_IRQ_handler
    .word RTC_alarm_IRQ_handler
    .word CRS_IRQ_handler
    .word PWR_SOTF_BLEACT_802ACT_RFPHASE_IRQ_handler
    .word IPCC_C1_RX_IRQ_handler
    .word IPCC_C1_TX_IRQ_handler
    .word HSEM_IRQ_handler
    .word LPTIM1_IRQ_handler
    .word LPTIM2_IRQ_handler
    .word LCD_IRQ_handler
    .word QSPI_IRQ_handler
    .word AES1_IRQ_handler
    .word AES2_IRQ_handler
    .word RNG_IRQ_handler
    .word FPU_IRQ_handler
    .word DMA2_chan1_IRQ_handler
    .word DMA2_chan2_IRQ_handler
    .word DMA2_chan3_IRQ_handler
    .word DMA2_chan4_IRQ_handler
    .word DMA2_chan5_IRQ_handler
    .word DMA2_chan6_IRQ_handler
    .word DMA2_chan7_IRQ_handler
    .word DMAMUX1_OVR_IRQ_handler

    /*
     * Setup weak aliases for each exception handler to the
     * default one. These can be updated later, or just
     * overridden since they're weak refs.
     * The reset_handler is set up separately.
     */
    .weak NMI_handler
    .thumb_set NMI_handler,default_interrupt_handler
    .weak hard_fault_handler
    .thumb_set hard_fault_handler,default_interrupt_handler
    .weak mem_manage_handler
    .thumb_set mem_manage_handler,default_interrupt_handler
    .weak bus_fault_handler
    .thumb_set bus_fault_handler,default_interrupt_handler
    .weak usage_fault_handler
    .thumb_set usage_fault_handler,default_interrupt_handler
    .weak SVC_handler
    .thumb_set SVC_handler,default_interrupt_handler
    .weak debug_monitor_handler
    .thumb_set debug_monitor_handler,default_interrupt_handler
    .weak pending_SV_handler
    .thumb_set pending_SV_handler,default_interrupt_handler
    .weak SysTick_handler
    .thumb_set SysTick_handler,default_interrupt_handler
    .weak window_watchdog_IRQ_handler
    .thumb_set window_watchdog_IRQ_handler,default_interrupt_handler
    .weak PVD_PVM_IRQ_handler
    .thumb_set PVD_PVM_IRQ_handler,default_interrupt_handler
    .weak tamper_stamper_LSECSS_handler
    .thumb_set tamper_stamper_LSECSS_handler,default_interrupt_handler
    .weak RTC_IRQ_handler
    .thumb_set RTC_IRQ_handler,default_interrupt_handler
    .weak flash_IRQ_handler
    .thumb_set flash_IRQ_handler,default_interrupt_handler
    .weak RCC_IRQ_handler
    .thumb_set RCC_IRQ_handler,default_interrupt_handler
    .weak EXTI0_IRQ_handler
    .thumb_set EXTI0_IRQ_handler,default_interrupt_handler
    .weak EXTI1_IRQ_handler
    .thumb_set EXTI1_IRQ_handler,default_interrupt_handler
    .weak EXTI2_IRQ_handler
    .thumb_set EXTI2_IRQ_handler,default_interrupt_handler
    .weak EXTI3_IRQ_handler
    .thumb_set EXTI3_IRQ_handler,default_interrupt_handler
    .weak EXTI4_IRQ_handler
    .thumb_set EXTI4_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan1_IRQ_handler
    .thumb_set DMA1_chan1_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan2_IRQ_handler
    .thumb_set DMA1_chan2_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan3_IRQ_handler
    .thumb_set DMA1_chan3_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan4_IRQ_handler
    .thumb_set DMA1_chan4_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan5_IRQ_handler
    .thumb_set DMA1_chan5_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan6_IRQ_handler
    .thumb_set DMA1_chan6_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan7_IRQ_handler
    .thumb_set DMA1_chan7_IRQ_handler,default_interrupt_handler
    .weak ADC1_IRQ_handler
    .thumb_set ADC1_IRQ_handler,default_interrupt_handler
    .weak USB_HP_IRQ_handler
    .thumb_set USB_HP_IRQ_handler,default_interrupt_handler
    .weak USB_LP_IRQ_handler
    .thumb_set USB_LP_IRQ_handler,default_interrupt_handler
    .weak C2SEV_PWR_C2H_IRQ_handler
    .thumb_set C2SEV_PWR_C2H_IRQ_handler,default_interrupt_handler
    .weak COMP_IRQ_handler
    .thumb_set COMP_IRQ_handler,default_interrupt_handler
    .weak EXTI9_5_IRQ_handler
    .thumb_set EXTI9_5_IRQ_handler,default_interrupt_handler
    .weak TIM1_break_IRQ_handler
    .thumb_set TIM1_break_IRQ_handler,default_interrupt_handler
    .weak TIM1_up_TIM16_IRQ_handler
    .thumb_set TIM1_up_TIM16_IRQ_handler,default_interrupt_handler
    .weak TIM1_trig_COM_IRQ_handler
    .thumb_set TIM1_trig_COM_IRQ_handler,default_interrupt_handler
    .weak TIM1_CC_IRQ_handler
    .thumb_set TIM1_CC_IRQ_handler,default_interrupt_handler
    .weak TIM2_IRQ_handler
    .thumb_set TIM2_IRQ_handler,default_interrupt_handler
    .weak PKA_IRQ_handler
    .thumb_set PKA_IRQ_handler,default_interrupt_handler
    .weak I2C1_EV_IRQ_handler
    .thumb_set I2C1_EV_IRQ_handler,default_interrupt_handler
    .weak I2C1_ER_IRQ_handler
    .thumb_set I2C1_ER_IRQ_handler,default_interrupt_handler
    .weak I2C3_EV_IRQ_handler
    .thumb_set I2C3_EV_IRQ_handler,default_interrupt_handler
    .weak I2C3_ER_IRQ_handler
    .thumb_set I2C3_ER_IRQ_handler,default_interrupt_handler
    .weak SPI1_IRQ_handler
    .thumb_set SPI1_IRQ_handler,default_interrupt_handler
    .weak SPI2_IRQ_handler
    .thumb_set SPI2_IRQ_handler,default_interrupt_handler
    .weak USART1_IRQ_handler
    .thumb_set USART1_IRQ_handler,default_interrupt_handler
    .weak LPUART1_IRQ_handler
    .thumb_set LPUART1_IRQ_handler,default_interrupt_handler
    .weak SAI1_IRQ_handler
    .thumb_set SAI1_IRQ_handler,default_interrupt_handler
    .weak TSC_IRQ_handler
    .thumb_set TSC_IRQ_handler,default_interrupt_handler
    .weak EXTI15_10_IRQ_handler
    .thumb_set EXTI15_10_IRQ_handler,default_interrupt_handler
    .weak RTC_alarm_IRQ_handler
    .thumb_set RTC_alarm_IRQ_handler,default_interrupt_handler
    .weak CRS_IRQ_handler
    .thumb_set CRS_IRQ_handler,default_interrupt_handler
    .weak PWR_SOTF_BLEACT_802ACT_RFPHASE_IRQ_handler
    .thumb_set PWR_SOTF_BLEACT_802ACT_RFPHASE_IRQ_handler,default_interrupt_handler
    .weak IPCC_C1_RX_IRQ_handler
    .thumb_set IPCC_C1_RX_IRQ_handler,default_interrupt_handler
    .weak IPCC_C1_TX_IRQ_handler
    .thumb_set IPCC_C1_TX_IRQ_handler,default_interrupt_handler
    .weak HSEM_IRQ_handler
    .thumb_set HSEM_IRQ_handler,default_interrupt_handler
    .weak LPTIM1_IRQ_handler
    .thumb_set LPTIM1_IRQ_handler,default_interrupt_handler
    .weak LPTIM2_IRQ_handler
    .thumb_set LPTIM2_IRQ_handler,default_interrupt_handler
    .weak LCD_IRQ_handler
    .thumb_set LCD_IRQ_handler,default_interrupt_handler
    .weak QSPI_IRQ_handler
    .thumb_set QSPI_IRQ_handler,default_interrupt_handler
    .weak AES1_IRQ_handler
    .thumb_set AES1_IRQ_handler,default_interrupt_handler
    .weak AES2_IRQ_handler
    .thumb_set AES2_IRQ_handler,default_interrupt_handler
    .weak RNG_IRQ_handler
    .thumb_set RNG_IRQ_handler,default_interrupt_handler
    .weak FPU_IRQ_handler
    .thumb_set FPU_IRQ_handler,default_interrupt_handler
    .weak DMA2_chan1_IRQ_handler
    .thumb_set DMA2_chan1_IRQ_handler,default_interrupt_handler
    .weak DMA2_chan2_IRQ_handler
    .thumb_set DMA2_chan2_IRQ_handler,default_interrupt_handler
    .weak DMA2_chan3_IRQ_handler
    .thumb_set DMA2_chan3_IRQ_handler,default_interrupt_handler
    .weak DMA2_chan4_IRQ_handler
    .thumb_set DMA2_chan4_IRQ_handler,default_interrupt_handler
    .weak DMA2_chan5_IRQ_handler
    .thumb_set DMA2_chan5_IRQ_handler,default_interrupt_handler
    .weak DMA2_chan6_IRQ_handler
    .thumb_set DMA2_chan6_IRQ_handler,default_interrupt_handler
    .weak DMA2_chan7_IRQ_handler
    .thumb_set DMA2_chan7_IRQ_handler,default_interrupt_handler
    .weak DMAMUX1_OVR_IRQ_handler
    .thumb_set DMAMUX1_OVR_IRQ_handler,default_interrupt_handler
.size vtable, .-vtable

/*
 * A 'Default' interrupt handler. This is where interrupts
 * which are not otherwise configured will go.
 * It is an infinite loop, because...well, we weren't
 * expecting the interrupt, so what can we do?
 */
.section .text.default_interrupt_handler,"ax",%progbits
default_interrupt_handler:
    default_interrupt_loop:
      B default_interrupt_loop
.size default_interrupt_handler, .-default_interrupt_handler
