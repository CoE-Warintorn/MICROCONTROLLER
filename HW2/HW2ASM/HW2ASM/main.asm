;
; HW2ASM.asm
;
; Created: 13/4/2561 16:58:45
; Author : Warintorn
;
.INCLUDE "m328pdef.inc"
.DEF	tmp		= r16
.DEF	switch_v= r17
.DEF	var_i	= r18
.DEF	mask	= r19
.DEF	var_a	= r20
.DEF	var_b	= r21
.DEF	TA		= r22
.DEF	TB		= r23
.EQU	num_sw	= 6
.EQU	ONEs	= 255
.EQU	ZEROs	= 0

.MACRO DELAY
	ldi		TB, 0x08
LB:	ldi		TA, 0xFF
LA:	dec		TA
	brne	LA
	dec		TB
	brne	LB
.ENDMACRO

.CSEG
.ORG	0x0000
	jmp		start
.ORG	PCI0addr
	jmp		PCINT_0

start:
	ldi		tmp, 0xC0
	out		DDRB, tmp
	ldi		tmp, 0x3F
	out		PORTB, tmp
	in		switch_v, PINB

    ldi		tmp, 0x01
	sts		PCICR, tmp
	ldi		tmp, 0x3F
	sts		PCMSK0, tmp

	sei

main:
	cpi		switch_v, ZEROs
	breq	LED_OFF
	ldi		ZL, low(CHALIEPLEXING_TB * 2)
	ldi		ZH, high(CHALIEPLEXING_TB * 2)

	ldi		var_i, ZEROs
	ldi		mask, 0x01
loop:
	cpi		var_i, num_sw
	breq	END
	lpm		var_a, Z+
	lpm		var_b, Z+
	mov		tmp, switch_v
	and		tmp, mask
	breq	skip
	out		DDRC, var_a
	out		PORTC, var_b
	DELAY
skip:
	inc		var_i
	lsl		mask
	rjmp	loop
LED_OFF:
	ldi		tmp, ONEs
	out		DDRC, tmp
	ldi		tmp, ZEROs
	out		PORTC, tmp
END:
	rjmp	main


PCINT_0:
	in		switch_v, PINB
	reti

CHALIEPLEXING_TB:
	.DB		0b1111011, 0b0000010	;	LED 1
	.DB		0b1111011, 0b0000001	;	LED 2
	.DB		0b1111110, 0b0000100	;	LED 3
	.DB		0b1111110, 0b0000010	;	LED 4
	.DB		0b1111101, 0b0000100	;	LED 5
	.DB		0b1111101, 0b0000001	;	LED 6