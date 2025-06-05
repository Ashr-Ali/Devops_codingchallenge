void Reset_Handler(void);
void Default_Handler(void);

extern unsigned long _estack;
extern int main(void);

void Reset_Handler(void) {
    // Initialize .data section
    extern unsigned long _sdata, _edata, _sidata;
    unsigned long *src = &_sidata;
    unsigned long *dst = &_sdata;
    while (dst < &_edata) *dst++ = *src++;
    
    // Zero .bss section
    extern unsigned long _sbss, _ebss;
    dst = &_sbss;
    while (dst < &_ebss) *dst++ = 0;
    
    // Call main
    main();
    
    // Infinite loop if main returns
    while (1);
}

void Default_Handler(void) {
    while (1);
}

// Vector table
__attribute__ ((section(".isr_vector")))
void (* const g_pfnVectors[])(void) = {
    (void *)&_estack,    // Initial stack pointer
    Reset_Handler,       // Reset handler
    Default_Handler,     // NMI
    Default_Handler,     // Hard fault
    // Add more handlers as needed
};