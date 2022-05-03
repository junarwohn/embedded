#include <config.h>
#include <s5pc100.h>

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:

	ldr	r0, =APB_DMC_BASE			@APB_DMC_BASE 0xE6000000

	ldr	r1, =INF_REG_BASE
	ldr	r2, [r1, #INF_REG3_OFFSET]
	cmp	r2, #BOOT_ONENAND
	beq	onenand_pop

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

