;
; HW1ASM.asm
;
; Created: 6/4/2561 10:13:51
; Author : Warintorn
;
.INCLUDE "m328pdef.inc"
.DEF		tmp			= r16
.DEF		distance	= r17
.DEF		SWITCH_V	= r18 
.DEF		LED			= r19
.DEF		VAR_I		= r20
.DEF		TIMES		= r21 
.DEF		TA			= r22 
.DEF		TB			= r23
.DEF		TC			= r24

.MACRO DELAY
	ldi		TC, 1
LC:	ldi		TB, 0xFF
LB:	ldi		TA, 0xFF
LA:	dec		TA
	brne	LA
	dec		TB
	brne	LB
	dec		TC
	brne	LC

.ENDMACRO

.MACRO COMPARE_AND_BRANCH_IF_KEYPRESSED
	cpi		tmp, 0xFF
	breq	skip
	ldi		VAR_I, 0
	mov		TIMES, tmp
	andi	TIMES, 0x0F
	andi	tmp, 0xF0
	lsr		tmp
	lsr		tmp
	lsr		tmp
	lsr		tmp
	in		LED, PORTD

LOOP:
	cp		VAR_I, TIMES
	breq	skip
	inc		VAR_I
	eor		LED, tmp
	out		PORTD, LED
	DELAY
	eor		LED, tmp
	out		PORTD, LED
	DELAY
	rjmp	LOOP
skip:
.ENDMACRO

.MACRO SCAN_KEY
	ldi		ZL, low(TB_7SEGMENT * 2)
	ldi		ZH, high(TB_7SEGMENT * 2)
	out		PORTB, tmp
	nop
	in		SWITCH_V, PINB
	andi	SWITCH_V, 0x0F
	add		SWITCH_V, distance
	subi	SWITCH_V, 7
	ldi		tmp, 0x00
	add		ZL, SWITCH_V
	adc		ZH, tmp
	lpm		tmp, Z
.ENDMACRO

.MACRO READ_KEY_PAD
	;	column 1
	ldi		tmp, 0b10111111
	ldi		distance, 0
	SCAN_KEY
	COMPARE_AND_BRANCH_IF_KEYPRESSED

	;	column 2
	ldi		tmp, 0b11011111
	ldi		distance, 9
	SCAN_KEY
	COMPARE_AND_BRANCH_IF_KEYPRESSED

	;	column 3
	ldi		tmp, 0b11101111
	ldi		distance, 18
	SCAN_KEY
	COMPARE_AND_BRANCH_IF_KEYPRESSED

.ENDMACRO

.CSEG
.ORG 0x0000
	jmp	START
	jmp	EXT_INT0_HANDLER

START:
	ldi		r17, LOW(RAMEND)   ; initialize stackpointer
	out		SPL, r17
	ldi		r17, HIGH(RAMEND)
	out		SPH, r17
	ldi		tmp, 0xFB
	out		DDRD, tmp
	ldi		tmp, 0xFF
	out		PORTD, tmp
	ldi		tmp, 0xF0
	out		DDRB, tmp
	ldi		tmp, 0x0F
	out		PORTB, tmp
	ldi		tmp, 0x02
	sts		EICRA, tmp
	ldi		tmp, 0x01
	out		EIMSK, tmp
	sei

MAIN: 
	ldi		tmp, 0x0F
	out		PORTB, tmp
	sei
	rjmp	MAIN

EXT_INT0_HANDLER:
	cli
	push	tmp
	in		tmp, SREG
	push	tmp
	READ_KEY_PAD
	pop		tmp
	out		SREG, tmp
	pop		tmp
	reti

TB_7SEGMENT:
	.DB		0x21, 0xFF, 0xFF, 0xFF, 0x24, 0xFF, 0x27, 0x2A, 0xFF, 0x22, 0xFF, 0xFF, 0xFF, 0x25
	.DB		0xFF, 0x28, 0x15, 0xFF, 0x23, 0xFF, 0xFF, 0xFF, 0x26, 0xFF, 0x29, 0x2B, 0xFF, 0xFF