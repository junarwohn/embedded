ENTRY(reset_handler)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 64K
}

SECTIONS
{
    .text: :
    {
        KEEP(*(.isr_vector))
        *(.text)
    } >FLASH
}