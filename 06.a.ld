MEMORY {
    dram_space (rwx) : ORIGIN = 0x80000000, LENGTH = 1024
}

SECTIONS {
    .text : {
        06.a.o(.text.bios)
    } >dram_space
}