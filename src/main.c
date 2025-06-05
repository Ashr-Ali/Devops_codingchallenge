#include <stdint.h>

// Register definitions for Cortex-M4
#define SYS_TICK_CTRL  (*((volatile uint32_t*)0xE000E010))
#define SYS_TICK_LOAD  (*((volatile uint32_t*)0xE000E014))
#define SYS_TICK_VAL   (*((volatile uint32_t*)0xE000E018))

// UART0 registers (simplified)
#define UART0_DR       (*((volatile uint32_t*)0x4000C000))
#define UART0_FR       (*((volatile uint32_t*)0x4000C018))
#define UART0_IMSC     (*((volatile uint32_t*)0x4000C038))

// GPIO registers (simplified)
#define GPIOA_DATA     (*((volatile uint32_t*)0x40020000))
#define GPIOA_DIR      (*((volatile uint32_t*)0x40020400))

void uart_putc(char c) {
    while (UART0_FR & (1 << 5)); // Wait while TX FIFO full
    UART0_DR = c;
}

void uart_puts(const char* str) {
    while (*str) {
        uart_putc(*str++);
    }
}

void delay(uint32_t cycles) {
    for (volatile uint32_t i = 0; i < cycles; i++);
}

void SystemInit(void) {
    // Enable GPIOA and UART0 clocks (simplified)
    // Configure GPIO pin for LED
    GPIOA_DIR |= (1 << 5); // Set PA5 as output
    
    // Configure UART0 (simplified)
    UART0_IMSC = 0; // Disable all interrupts
    
    uart_puts("System initialized\n");
}

int main(void) {
    SystemInit();
    uart_puts("Starting main loop\n");
    
    while (1) {
        GPIOA_DATA ^= (1 << 5); // Toggle LED
        uart_puts("LED toggled\n");
        delay(1000000);
    }
    
    return 0;
}