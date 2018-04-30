;
; 2Pulse_ASM.asm
;
; Created: 1/5/2561 1:44:42
; Author : Warintorn
;


.INCLUDE "m328pdef.inc"
.DEF	tmp = r16
.DEF	op	= r17


.CSEG
.ORG 0x00
	jmp		start
.ORG OC1Aaddr
	jmp		compa_handler
.ORG OC1Baddr
	jmp		compb_handler

start:
	; PORT C 1, 0 as Output
	ldi		tmp, 0x03
	out		DDRC, tmp
	ldi		tmp, 0x00
	out		PORTC, tmp

	; Set Timer1
	sts		TCNT1L, tmp
	sts		TCNT1H, tmp
	; Pulse 1
	ldi		tmp, 0x4E
	sts		OCR1AH, tmp
	ldi		tmp, 0x1F
	sts		OCR1AL, tmp
	; Pulse 2 diff 90
	ldi		tmp, 0x27
	sts		OCR1BH, tmp
	ldi		tmp, 0x10
	sts		OCR1BL, tmp

	; SET CTC mode
	ldi		tmp, 0x00
	sts		TCCR1A, tmp

	; SET Clock / 8
	ldi		tmp, 0x0A
	sts		TCCR1B, tmp

	; Enable CompA and CompB
	ldi		tmp, 0x06
	sts		TIMSK1, tmp

	sei
main:
	rjmp main

compa_handler:
	in		tmp, PORTC
	ldi		op, 0x01
	eor		tmp, op
	out		PORTC, tmp
	reti

compb_handler:
	in		tmp, PORTC
	ldi		op, 0x02
	eor		tmp, op
	out		PORTC, tmp
	reti
