/*
    Linker script for PYBD with STM32F767

    Memory layout for mboot configuration (this here describes the app part):

    FLASH_APP   .isr_vector
    FLASH_APP   .text
    FLASH_APP   .data

    RAM         .data
    RAM         .bss
    RAM         .heap
    RAM         .stack
*/

/* Specify the memory areas */
MEMORY
{
    FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 2048K
    FLASH_APP (rx)  : ORIGIN = 0x08008000, LENGTH = 2016K   /* sectors 1-11 3x32K 1*128K 7*256K */
    FLASH_ROMFS (rx): ORIGIN = 0x90000000, LENGTH = 2048K   /* external QSPI, at least 2MiB */
    RAM (rwx)       : ORIGIN = 0x20000000, LENGTH = 512K    /* DTCM=128k, SRAM1=368K, SRAM2=16K */
}

/* produce a link error if there is not this amount of RAM for these sections */
_minimum_stack_size = 2K;
_minimum_heap_size = 16K;

/* Define the stack.  The stack is full descending so begins just above last byte
   of RAM.  Note that EABI requires the stack to be 8-byte aligned for a call. */
_estack = ORIGIN(RAM) + LENGTH(RAM) - _estack_reserve;
_sstack = _estack - 24K;

/* RAM extents for the garbage collector */
_ram_start = ORIGIN(RAM);
_ram_end = ORIGIN(RAM) + LENGTH(RAM);
_heap_start = _ebss; /* heap starts just after statically allocated memory */
_heap_end = _sstack;

/* ROMFS location */
_micropy_hw_romfs_part0_start = ORIGIN(FLASH_ROMFS);

INCLUDE common_bl.ld
