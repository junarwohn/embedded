#include <config.h>
#include <s5pc100.h>

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:

	ldr	r0, =APB_DMC_BASE			@APB_DMC_BASE 0xE6000000

	ldr	r1, =INF_REG_BASE
	ldr	r2, [r1, #INF_REG3_OFFSET]
	cmp	r2, #BOOT_ONENAND
	beq	onenand_pop





#if defined(MDDR)

single:


/************ mDDR initialization *************/
      
	ldr   r1, =0x69101000              @ Phycontrol0 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x000000F4              @ Phycontrol1 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL1]   @ 0xE600_001C

	ldr   r1, =0x00000000              @ Phycontrol2 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL2]   @ 0xE600_0020

	ldr   r1, =0x69101002              @ DLL on
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x69101003              @ Dll start
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018


	ldr   r2, =0xE6000040              @ DMC_PHYSTATUS0


loop1:

	ldr   r1, [r2]                     @ Check DLL lock
	ands  r1, r1, #4
	beq   loop1

	ldr   r1, [r2]
	mov   r1, r1,  LSR #(0x6)
	and   r1, r1, #(0xff)
	mov   r1, r1, LSL  #(0x18)
	ldr   r2, =0xE6000018              @ DMC_PHYCONTROL0
	ldr   r3, [r2]
	bic   r3, r3, #(0xff000000)
	orr   r1, r3, r2
	str   r1, [r2]



	ldr   r1, =0x69101003              @ Force Value locking
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x69101001              @ Dll off
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018



#if 0
	ldr   r1, =0x6A101000              @ Phycontrol0 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x00008484              @ Phycontrol1 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL1]   @ 0xE600_001C

	ldr   r1, =0x00000000              @ Phycontrol2 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL2]   @ 0xE600_0020

#endif
/************ DLL initialization - END *************/


	@ldr   r1, =0x0FF01010              @ auto refresh off
	ldr   r1, =0x00FF2390              @ auto refresh off
	str   r1, [r0, #DMC_CONCONTROL]    @ 0xE600_0000
	      
	ldr   r1, =0x00212110              @ BL=4 , 2 chip , DDR2
	str   r1, [r0, #DMC_MEMCONTROL]    @ 0xE600_0004
	      
	      
	@ldr   r1, =0x20F01322              @ 128MB config , 4banks , linear, Row=14bit,COL=10bit
	ldr   r1, =0x20F01322              @ 128MB config , 4banks , linear, Row=14bit,COL=10bit
	str   r1, [r0, #DMC_MEMCONFIG0]    @ 0xE600_0008
	      
	ldr   r1, =0x40F00322
	str   r1, [r0, #DMC_MEMCONFIG1]    @ 0xE600_000C
	      
	ldr   r1, =0x20000000
	str   r1, [r0, #DMC_PRECHCONFIG]   @ 0xE600_0014


	ldr   r1, =0x001000FF              @ PwrdnConfig
	str   r1, [r0, #DMC_PWRDNCONFIG]   @ 0xE600_0028




	ldr   r1, =0x0000050E		
	str   r1, [r0, #DMC_TIMINGAREF]    @ 0xE600_0030

	ldr   r1, =0x0C233287              @ TimingRow 	 @166MHz
	str   r1, [r0, #DMC_TIMINGROW]     @ 0xE600_0034


	ldr   r1, =0x32330303              @ CL=3
	str   r1, [r0, #DMC_TIMINGDATA]    @ 0xE600_0038

	ldr   r1, =0x04141433              @ Timing Power
	str   r1, [r0, #DMC_TIMINGPOWER]   @ 0xE600_003C



/* Direct Command for mDDR */
	ldr   r1, =0x07000000              @ chip0 Deselect NOP
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x01000000              @ chip0 PALL
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x00020000              @ chip0 EMRS1
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010

	ldr   r1, =0x00000032              @ chip0 MRS CL=3, Burst Length=4
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010

	ldr   r1, =0x05000000              @ chip0 REFA
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010

	ldr   r1, =0x05000000              @ chip0 REFA
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010		
		                        
	ldr   r1, =0x00000032              @ chip0 MRS CL=3, Burst Length=4
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010







#if 0
	ldr   r1, =0x07100000              @ chip1 Deselect NOP
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x01100000              @ chip1 PALL
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x00120000              @ chip1 EMRS1
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010

	ldr   r1, =0x00100032              @ chip1 MRS CL=3, Burst Length=4
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010

	ldr   r1, =0x05100000              @ chip1 REFA
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010

	ldr   r1, =0x05100000              @ chip1 REFA
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010		
		               
	ldr   r1, =0x00100032              @ chip1 MRS CL=3, Burst Length=4
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
#endif




/* Direct Command for LPDDR  - END */
 
	@ldr   r1, =0x00FF20B0              @ ConControl auto refresh on
	ldr   r1, =0x00FF23B0              @ ConControl auto refresh on
	str   r1, [r0, #DMC_CONCONTROL]    @ 0xE600_0000

#if 0
	ldr   r1, =0x001000FF              @ PwrdnConfig
	str   r1, [r0, #DMC_PWRDNCONFIG]   @ 0xE600_0028
#endif

	ldr   r1, =0x00212113              @ MemControl
	str   r1, [r0, #DMC_MEMCONTROL]    @ 0xE600_0004

	b	exit_cpu_init
	
#endif        	
        	

#if defined(DDR2)     	

single:
	LDR	r1,=0x6E101000		@ Phycontrol0 DLL parameter setting
	STR	r1,[r0,#0x18]
	LDR     r1,=0x000000F4		@ Phycontrol1 DLL parameter setting
	STR	r1,[r0,#0x1c]
	LDR     r1,=0x00000000		@ Phycontrol2 DLL parameter setting
	STR	r1,[r0,#0x20]
	LDR     r1,=0x6E101002		@ Dll on
	STR	r1,[r0,#0x18]
	LDR     r1,=0x6E101003		@ Dll start
	STR	r1,[r0,#0x18]
	
wait_for_dll_locking:
 	ldr	r2, [r0, #0x40]		@ DMC_PHYSTATUS0
 	bic	r2, #0xfffffffb
 	mov	r2, r2, lsr #2
 	cmp	r2, #0x1
 	bne	wait_for_dll_locking
 	
 	ldr	r2, [r0, #0x40]
 	bic	r2, #0xffffc03f
 	mov	r2, r2, lsr #6
 	
 	mov	r2,r2,lsl #24
 	ldr	r1, =0x00101003
 	orr	r1,r1,r2
 	
 	ldr	r4, =0xF4010000
 	str	r1, [r4, #4]
 	
	str	r1, [r0, #0x18]		@ Force Value locking
	ldr	r1, =0x00101001
	orr	r1,r1,r2
	
	str	r1, [r0, #0x18]
	
	ldr	r1, =0x00FF2010		@ auto refresh off
	str     r1, [r0]
	
	LDR	r1,=0x00FF2010
	STR	r1,[r0]
	@LDR	r1,=0x00212400		@ MemControl, BL=4, 2 Chip, DDR2
	LDR	r1,=0x00202400		@ MemControl, BL=4, 1 Chip, DDR2
	STR	r1,[r0,#0x4]
	@LDR	r1,=0x20F80313		@ Memconfig0, 128MB Enable
	LDR	r1,=0x20F00313		@ Memconfig0, 256MB Enable
	STR	r1,[r0,#0x8]
	@LDR	r1,=0x40F80313		@ Memconfig1, 128MB Enable
	LDR	r1,=0x40F00313		@ Memconfig1, 256MB Enable
	STR	r1,[r0,#0xc]
	LDR	r1,=0x20000000		@ PrechConfig
	STR	r1,[r0,#0x14]

        LDR     r1,=0x00000A26          @ TimingAref, 7.8us*333Mhz=2598(0xA26)
        STR     r1,[r0,#0x30]
        LDR     r1,=0x39577694          @ TimingRow,  333Mhz
        STR     r1,[r0,#0x34]
        LDR     r1,=0x47450204          @ TimingData, 333Mhz, CL=5
        STR     r1,[r0,#0x38]
        LDR     r1,=0x16C80232          @ TimingPower,333Mhz
        STR     r1,[r0,#0x3c]

#if 0
#if defined(CONFIG_CLK_666_133_66)
	LDR	r1,=0x0000040E		@ TimingAref, 7.8us*133Mhz=1038(0x40E)
        STR     r1,[r0,#0x30]
	LDR	r1,=0x172332C8		@ TimingRow,  133Mhz
        STR     r1,[r0,#0x34]
	LDR	r1,=0x23250204		@ TimingData, 133Mhz, CL=5
        STR     r1,[r0,#0x38]
	LDR	r1,=0x09C80232		@ TimingPower,133Mhz
        STR     r1,[r0,#0x3c]
#elif defined(CONFIG_CLK_666_166_66) || defined(CONFIG_CLK_833_166_66)
	LDR	r1,=0x0000050F		@ TimingAref, 7.8us*166Mhz=1295(0x50F)
        STR     r1,[r0,#0x30]
	LDR	r1,=0x1D24434A		@ TimingRow,  166Mhz
        STR     r1,[r0,#0x34]
	LDR	r1,=0x24250204		@ TimingData, 166Mhz, CL=5
        STR     r1,[r0,#0x38]
	LDR	r1,=0x0BC80232		@ TimingPower,166Mhz
        STR     r1,[r0,#0x3c]
#elif defined(CONFIG_CLK_666_222_66) || defined(CONFIG_CLK_833_208_66)
	LDR	r1,=0x000006C4		@ TimingAref, 7.8us*222Mhz=1732(0x6C4)
        STR     r1,[r0,#0x30]
	LDR	r1,=0x2635548E		@ TimingRow,  222Mhz
        STR     r1,[r0,#0x34]
	LDR	r1,=0x35350204		@ TimingData, 222Mhz, CL=5
        STR     r1,[r0,#0x38]
	LDR     r1,=0x0FC80232		@ TimingPower,222Mhz
        STR     r1,[r0,#0x3c]
#elif defined(CONFIG_CLK_666_333_66) || defined(CONFIG_CLK_833_280_66)
	LDR	r1,=0x00000A26		@ TimingAref, 7.8us*333Mhz=2598(0xA26)
        STR     r1,[r0,#0x30]
	LDR     r1,=0x39577694		@ TimingRow,  333Mhz
        STR     r1,[r0,#0x34]
	LDR     r1,=0x47450204		@ TimingData, 333Mhz, CL=5
        STR     r1,[r0,#0x38]
	LDR     r1,=0x16C80232		@ TimingPower,333Mhz
        STR     r1,[r0,#0x3c]
#endif
#endif

	
	LDR	r1,=0x07000000		@ DMC_DirectCmd, Chip0 Deselect
	STR	r1,[r0,#0x10]
	LDR	r1,=0x01000000		@ DMC_DirectCmd, Chip0 PALL
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00020000		@ DMC_DirectCmd, Chip0 EMRS2
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00030000		@ DMC_DirectCmd, Chip0 EMRS3
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00010400		@ DMC_DirectCmd, Chip0 EMRS1 (MEM Dll on = DQS# disable)
	@LDR	r1,=0x00010444		@ DMC_DirectCmd, Chip0 EMRS1 (MEM Dll on = DOQ# disable, RTT- 50Ohm)
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00000552		@ DMC_DirectCmd, Chip0 MRS (MEM Dll Reset) CL=5, BL=4
	STR	r1,[r0,#0x10]
	LDR	r1,=0x01000000		@ Chip0 PALL
	STR	r1,[r0,#0x10]
	LDR	r1,=0x05000000		@ Chip0 REFA
	STR	r1,[r0,#0x10]
	LDR	r1,=0x05000000		@ Chip0 REFA
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00000452		@ DMC_DirectCmd, Chip0 MRS (MEM Dll unReset) CL=5, BL=4
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00010780		@ Chip0 EMRS1 (OCD Default)
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00110402		@ chip0 EMRS1 (OCD exit)  Reduced Strength	
	STR	r1,[r0,#0x10]
	
	LDR	r1,=0x00FF20B0		@ ConControl PHY driving , auto refresh on , out of order scheduling
	STR	r1,[r0]
	LDR	r1,=0x00100002		@ PwrdnConfig
	STR	r1,[r0,#0x28]
	LDR	r1,=0xFF202400		@ MemControl
	STR	r1,[r0,#0x4]

        b	exit_cpu_init        	
        	        
#endif        	
        	
        	
        	
        	
        	
        	
        	
        	

#if 0        	
single:
	LDR	r1,=0x6E101000		@ Phycontrol0 DLL parameter setting
	STR	r1,[r0,#0x18]
	LDR     r1,=0x000000F4		@ Phycontrol1 DLL parameter setting
	STR	r1,[r0,#0x1c]
	LDR     r1,=0x00000000		@ Phycontrol2 DLL parameter setting
	STR	r1,[r0,#0x20]
	LDR     r1,=0x6E101002		@ Dll on
	STR	r1,[r0,#0x18]
	LDR     r1,=0x6E101003		@ Dll start
	STR	r1,[r0,#0x18]
	
wait_for_dll_locking:
 	ldr	r2, [r0, #0x40]
 	bic	r2, #0xfffffffb
 	mov	r2, r2, lsr #2
 	cmp	r2, #0x1
 	bne	wait_for_dll_locking
 	
 	ldr	r2, [r0, #0x40]
 	bic	r2, #0xffffc03f
 	mov	r2, r2, lsr #6
 	
 	mov	r2,r2,lsl #24
 	ldr	r1, =0x00101003
 	orr	r1,r1,r2
 	
 	ldr	r4, =0xF4010000
 	str	r1, [r4, #4]
 	
	str	r1, [r0, #0x18]
	ldr	r1, =0x00101001
	orr	r1,r1,r2
	
	str	r1, [r0, #0x18]
	
	ldr	r1, =0x00FF2010		@ auto refresh off
	str     r1, [r0]
	
	LDR	r1,=0x00FF2010
	STR	r1,[r0]
	@LDR	r1,=0x00212400		@ MemControl, BL=4, 2 Chip, DDR2
	LDR	r1,=0x00202400		@ MemControl, BL=4, 1 Chip, DDR2
	STR	r1,[r0,#0x4]
	@LDR	r1,=0x20F80313		@ Memconfig0, 128MB Enable
	LDR	r1,=0x20F00313		@ Memconfig0, 256MB Enable
	STR	r1,[r0,#0x8]
	@LDR	r1,=0x40F80313		@ Memconfig1, 128MB Enable
	LDR	r1,=0x40F00313		@ Memconfig1, 256MB Enable
	STR	r1,[r0,#0xc]
	LDR	r1,=0x20000000		@ PrechConfig
	STR	r1,[r0,#0x14]
	LDR	r1,=0x0000050E		@ TimingAref, 7.8us*166Mhz=1294(0x50E)
	@LDR	r1,=0x0000040E		@ TimingAref, 7.8us*133Mhz=----(0x40E)
	@LDR	r1,=0x0000050E		@ TimingAref, 7.8us*333Mhz=2597(0xA25)
	STR	r1,[r0,#0x30]
	@LDR	r1,=0x16233287		@ TimingRow
	LDR	r1,=0x16233288		@ TimingRow, 166Mhz
	@LDR	r1,=0x32566370		@ TimingRow, 333Mhz
	STR	r1,[r0,#0x34]
	@LDR	r1,=0x23250304		@ TimingData	
	LDR	r1,=0x24250304		@ TimingData, CL=5, 166Mhz
	@LDR	r1,=0x36350304		@ TimingData, CL=5, 333Mhz
	STR	r1,[r0,#0x38]
	LDR	r1,=0x09C80232		@ TimingPower
	@LDR	r1,=0x0EC80233		@ TimingPower, 333Mhz
	STR	r1,[r0,#0x3c]
	
	LDR	r1,=0x07000000		@ DMC_DirectCmd, Chip0 Deselect
	STR	r1,[r0,#0x10]
	LDR	r1,=0x01000000		@ DMC_DirectCmd, Chip0 PALL
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00020000		@ DMC_DirectCmd, Chip0 EMRS2
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00030000		@ DMC_DirectCmd, Chip0 EMRS3
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00010400		@ DMC_DirectCmd, Chip0 EMRS1 (MEM Dll on = DQS# disable)
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00000552		@ DMC_DirectCmd, Chip0 MRS (MEM Dll Reset) CL=5, BL=4
	STR	r1,[r0,#0x10]
	LDR	r1,=0x01000000		@ Chip0 PALL
	STR	r1,[r0,#0x10]
	LDR	r1,=0x05000000		@ Chip0 REFA
	STR	r1,[r0,#0x10]
	LDR	r1,=0x05000000		@ Chip0 REFA
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00000452		@ DMC_DirectCmd, Chip0 MRS (MEM Dll unReset) CL=5, BL=4
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00010780		@ Chip0 EMRS1 (OCD Default)
	STR	r1,[r0,#0x10]
	LDR	r1,=0x00110402		@ chip0 EMRS1 (OCD exit)  Reduced Strength	
	STR	r1,[r0,#0x10]
	
	LDR	r1,=0x00FF20B0		@ ConControl PHY driving , auto refresh on , out of order scheduling
	STR	r1,[r0]
	LDR	r1,=0x00100002		@ PwrdnConfig
	STR	r1,[r0,#0x28]
	LDR	r1,=0xFF202400		@ MemControl
	STR	r1,[r0,#0x4]

        b	exit_cpu_init
#endif



#if 0
@ Odroid DDR2 setting.
single:


/************ DLL initialization *************/
      
	ldr   r1, =0x6A101000              @ Phycontrol0 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x000084F4              @ Phycontrol1 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL1]   @ 0xE600_001C

	ldr   r1, =0x00000000              @ Phycontrol2 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL2]   @ 0xE600_0020

	ldr   r1, =0x6A101002              @ DLL on
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x6A101003              @ Dll start
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018


	ldr   r2, =0xE6000040              @ DMC_PHYSTATUS0


loop1:

	ldr   r1, [r2]                     @ Check DLL lock
	ands  r1, r1, #4
	beq   loop1

	ldr   r1, [r2]
	mov   r1, r1,  LSR #(0x6)
	and   r1, r1, #(0xff)
	mov   r1, r1, LSL  #(0x18)
	ldr   r2, =0xE6000018              @ DMC_PHYCONTROL0
	ldr   r3, [r2]
	bic   r3, r3, #(0xff000000)
	orr   r1, r3, r2
	str   r1, [r2]



	ldr   r1, =0x6A101003              @ Force Value locking
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x6A101009              @ Dll off
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018



#if 0
	ldr   r1, =0x6A101000              @ Phycontrol0 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL0]   @ 0xE600_0018

	ldr   r1, =0x00008484              @ Phycontrol1 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL1]   @ 0xE600_001C

	ldr   r1, =0x00000000              @ Phycontrol2 DLL parameter setting
	str   r1, [r0, #DMC_PHYCONTROL2]   @ 0xE600_0020

#endif
/************ DLL initialization - END *************/


	ldr   r1, =0x0FF01010              @ auto refresh off
	str   r1, [r0, #DMC_CONCONTROL]    @ 0xE600_0000
	      
	ldr   r1, =0x00212400              @ BL=4 , 2 chip , DDR2
	str   r1, [r0, #DMC_MEMCONTROL]    @ 0xE600_0004
	      
	      
	ldr   r1, =0x20F80313              @ 128MB config , 8banks , linear, Row=13bit,COL=10bit
	str   r1, [r0, #DMC_MEMCONFIG0]    @ 0xE600_0008
	      
	ldr   r1, =0x40F80313
	str   r1, [r0, #DMC_MEMCONFIG1]    @ 0xE600_000C
	      
	ldr   r1, =0x20000000
	str   r1, [r0, #DMC_PRECHCONFIG]   @ 0xE600_0014


	ldr   r1, =0x00100004              @ PwrdnConfig
	str   r1, [r0, #DMC_PWRDNCONFIG]   @ 0xE600_0028




	ldr   r1, =0x0000050E		
	str   r1, [r0, #DMC_TIMINGAREF]    @ 0xE600_0030

	ldr   r1, =0x16233297              @ TimingRow 	 @166MHz
	str   r1, [r0, #DMC_TIMINGROW]     @ 0xE600_0034


	ldr   r1, =0x23230000              @ CL=3
	str   r1, [r0, #DMC_TIMINGDATA]    @ 0xE600_0038

	ldr   r1, =0x07c80232              @ Timing Power
	str   r1, [r0, #DMC_TIMINGPOWER]   @ 0xE600_003C



/* Direct Command for DDR2 */
	ldr   r1, =0x07000000              @ chip0 Deselect
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x01000000              @ chip0 PALL
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x00020000              @ chip0 EMRS2
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x00030000              @ chip0 EMRS3
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
         
	ldr   r1, =0x00010400              @ chip0 EMRS1 (MEM DLL on = DQS# disable)
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
         
         
	ldr   r1, =0x00000532              @ chip0 MRS (MEM DLL reset) CL=3, Burst Length=4
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x01000000              @ chip0 PALL
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x05000000              @ chip0 REFA
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
	      
	ldr   r1, =0x05000000              @ chip0 REFA
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
         
	ldr   r1, =0x00000432              @ chip0 MRS (MEM DLL unreset) , BL=4 , CL=3 
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
         
	ldr   r1, =0x00010780              @ chip0 EMRS1 (OCD default)
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010
                           
	ldr   r1, =0x00010402              @ chip0 EMRS1 (OCD exit)  Reduced Strength         
	str   r1, [r0, #DMC_DIRECTCMD]     @ 0xE600_0010


/* Direct Command for LPDDR  - END */
 
	ldr   r1, =0x00FF20B0              @ ConControl auto refresh on
	str   r1, [r0, #DMC_CONCONTROL]    @ 0xE600_0000

#if 0
	ldr   r1, =0x001000FF              @ PwrdnConfig
	str   r1, [r0, #DMC_PWRDNCONFIG]   @ 0xE600_0028
#endif

	ldr   r1, =0x00212413              @ MemControl
	str   r1, [r0, #DMC_MEMCONTROL]    @ 0xE600_0004

	b	exit_cpu_init
#endif


onenand_pop:
	ldr	r1, =0x50101000				@Phycontrol0 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x000000F4				@Phycontrol1 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00000000				@Phycontrol2 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL2]

	ldr	r1, =0x50101002				@Dll on
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x50101003				@dll start
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x50101003				@Force Value locking
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x50101001				@Dll off
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0xFF001010				@auto refresh off
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00212100				@Dll off
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x28F80222
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =0x20F80222
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0x20000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x0000050E
	str	r1, [r0, #DMC_TIMINGAREF]

	ldr	r1, =0x0C233287				@TimingRow	@133MHz
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x32330303
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x04141433				@Timing Power
	str	r1, [r0, #DMC_TIMINGPOWER]

	ldr	r1, =0x07000000				@chip0 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01000000				@chip0 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00000032				@chip0 MRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x07100000				@chip1 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01100000				@chip1 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00100032				@chip1 MRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0xFF002030				@ConControl auto refresh on
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00100002				@PwrdnConfig
	str	r1, [r0, #DMC_PWRDNCONFIG]

	ldr	r1, =0xFF212100				@MemControl
	str	r1, [r0, #DMC_MEMCONTROL]

	b	exit_cpu_init

exit_cpu_init:
	mov	pc, lr


/* Below code is for ARM926EJS and ARM1026EJS */
	.globl cleanDCache
cleanDCache:
	mrc	p15, 0, pc, c7, c10, 3	/* test/clean D-Cache */
	bne	cleanDCache
	mov	pc, lr

	.globl cleanFlushDCache
cleanFlushDCache:
	mrc	p15, 0, pc, c7, c14, 3	/* test/cleanflush D-Cache */
	bne	cleanFlushDCache
	mov	pc, lr

	.globl cleanFlushCache
cleanFlushCache:
	mrc	p15, 0, pc, c7, c14, 3	/* test/cleanflush D-Cache */
	bne	cleanFlushCache
	mcr	p15, 0, r0, c7, c5, 0	/* flush I-Cache */
	mov	pc, lr

	.ltorg

