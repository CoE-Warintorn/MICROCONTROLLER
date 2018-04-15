;
; TIMER0_ASM.asm
;
; Created: 15/4/2561 9:51:21
; Author : Warintorn
;
.INCLUDE "m328pdef.inc"
.DEF	tmp	= r16
.DEF	one	= r17
.CSEG
.ORG	0x0000
	jmp		start
.ORG	OVF0addr
	jmp		TIMER0_OVF_HANDLER

start:
	ldi		one, 0x01
	out		DDRC, one
	sts		TIMSK0, one
	ldi		tmp, 0x03
	out		TCCR0B, tmp
	ldi		tmp, 0x00
	out		TCCR0A, tmp
	ldi		tmp, 189
	out		TCNT0, tmp
	sei

MAIN:
	rjmp MAIN


TIMER0_OVF_HANDLER:
	ldi		tmp, 189
	out		TCNT0, tmp
	in		tmp, PORTC
	eor		tmp, one
	out		PORTC, tmp
	reti