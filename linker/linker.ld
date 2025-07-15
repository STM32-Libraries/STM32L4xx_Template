
ENTRY(Reset_Handler)

_estack = ORIGIN(RAM) + LENGTH(RAM);

/* Memory definition */
MEMORY
{
  RAM  (xrw)     : ORIGIN = 0x20000000, LENGTH = 48K
  SRAM2 (xrw)    : ORIGIN = 0x10000000,   LENGTH = 16K
  FLASH  (xr)    : ORIGIN = 0x08000000, LENGTH = 256K
}


/* Output Sections */
SECTIONS
{
  /* The startup code into "FLASH" Rom type memory */
  .isr_vector :
  {
    . = ALIGN(4);
    *(.isr_vector)
    . = ALIGN(4);
  } > FLASH

  /* The program code and other data into "FLASH" Rom type memory */
  .text :
  {
    . = ALIGN(4);
    *(.text)
    *(.text*)
    . = ALIGN(4);
    _etext = .;
  } > FLASH

  /* Constant data into "FLASH" Rom type memory */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)    /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)   /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } > FLASH

  /* The READONLY keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  .preinit_array () : 
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
    . = ALIGN(4);
  } >FLASH

  /* The READONLY keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  .init_array () : 
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
    . = ALIGN(4);
  } >FLASH

  /* The READONLY keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  .fini_array () : 
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
    . = ALIGN(4);
  } >FLASH


  _sidata = LOADADDR(.data);

  .data :
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } > RAM AT > FLASH

  _sisram2 = LOADADDR(.sram2);

  /* SRAM2 section
  *
  * IMPORTANT NOTE!
  * If initialized variables will be placed in this section,
  * the startup code needs to be modified to copy the init-values.
  */
  .sram2 :
  {
    . = ALIGN(4);
    _ssram2 = .;       /* create a global symbol at sram2 start */
    *(.sram2)
    *(.sram2*)

    . = ALIGN(4);
    _esram2 = .;       /* create a global symbol at sram2 end */
  } >SRAM2 AT> FLASH

  .bss :
  {
    _sbss = .;
    *(.bss)
    *(.bss*)
    . = ALIGN(4);
    _ebss = .;
  } > RAM

    /* Remove information from the compiler libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
