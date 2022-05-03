/*
 * Command for accessing DataFlash.
 *
 * Copyright (C) 2008 Atmel Corporation
 */
#include <common.h>
//#include <stdio.h>
//#include <stdlib.h>


static int do_test(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
//   0xC0000000
//   0xC1000000

#if 1

   vu_long  *addr, *start, *end;
   ulong val;
   ulong readback;
   int     rcode = 0;

   vu_long  len;
   vu_long  offset;
   vu_long  test_offset;
   vu_long  pattern;
   vu_long  temp;
   vu_long  anti_pattern;
   vu_long  num_words;

   int   j;
   int iterations = 1;

   static const ulong bitpattern[] = {
      0x00000001, /* single bit */
      0x00000003, /* two adjacent bits */
      0x00000007, /* three adjacent bits */
      0x0000000F, /* four adjacent bits */
      0x00000005, /* two non-adjacent bits */
      0x00000015, /* three non-adjacent bits */
      0x00000055, /* four non-adjacent bits */
      0xaaaaaaaa, /* alternating 1/0 */
   };




   start = (unsigned long *)(0x20000000);
   end = (unsigned long *)(0x27E00000);
   pattern = 0;


   len = ((unsigned long)end - (unsigned long)start)/sizeof(volatile unsigned long);

   addr = start;

   printf("DDR2 Data init 0x00\n");
   
   for(offset=0; offset<len; offset++){
      start[offset] = 0x00000000;
   }

   printf ("Testing %08x ... %08x:\n", (uint)start, (uint)end);
   
   while(1){


      printf("Iteration: %6d ... addr : 0x%.8lx\n", iterations, (ulong)addr);
      iterations++;

     

      for(j = 0; j < sizeof(bitpattern)/sizeof(bitpattern[0]); j++) {
         val = bitpattern[j];
         for(; val != 0; val <<= 1) {
            //Disp0("AAA\n");
            *addr  = val;
            //Disp0("BBB\n");
            //*dummy  = ~val; /* clear the test data off of the bus */
            readback = *addr; 
            //Disp0("CCC\n");
            if(readback != val) {
               printf ("FAILURE (data line): expected %08lx, actual %08lx\n", val, readback);
               return 1;
            }
            *addr  = ~val;
            //*dummy  = val;
            readback = *addr;
            if(readback != ~val) {
               printf ("FAILURE (data line): Is %08lx, should be %08lx\n", readback, ~val);
               return 1;
            }
         }
      }

      printf("addr = 0x%.8lx ... pattern = 0x%.8lx write done.\n", (ulong)addr, (ulong)readback);

      for(offset=0; offset<len; offset++){
         if(start[offset] != 0x00000000){
            if((&start[offset]) != addr){
               printf ("\nFAILURE (read/write) @ 0x%.8lx: expected 0x%.8lx\n", (ulong)&start[offset], start[offset]);
            }
         }
      }

      printf("verity done\n");


      if(ctrlc()){
         putc ('\n');
         return 1;
      }


      






      
      *addr = 0x00000000;
      addr++;

      
      if(addr == 0x27E00004){
         printf("\nTest End\n");
      }
   }













#else
   unsigned int data[10];
   unsigned int addr[10];
   unsigned int data1;
   int memError=0;
   unsigned int i;


   printf("Write Data...\n");
   for(i=0;i<0x1000000;i+=4){
      *(volatile unsigned int *)(0xC0000000+i) = i;
//      printf("addr = 0x%x, data = 0x%x\n", 0xC0000000+i, i);
      if(!(i&0xFFFF)){
         printf("-");
      }
      if(!(i&0xFF)){
         printf("\n");
      }
   }
   printf("\n");
   printf("Read / Verity Data...\n");
   for(i=0;i<0x1000000;i+=4){
      data1 = *(volatile unsigned int *)(0xC0000000+i);
      if(!(i&0xFFFF)){
         printf("+");
      }
      if(!(i&0xFF)){
         printf("\n");
      }
      if(data1 != i){
         memError = 1;
      }
   }

    if(memError==0){
        printf("O.K.\n");        
    }
    else{
      printf("Not O.K.\n");
      return 0;
    }
#endif


   return 0;
}


U_BOOT_CMD(
   xtest,   CFG_MAXARGS,   0, do_test,
   "xtest\n",
   "bbb\n");
