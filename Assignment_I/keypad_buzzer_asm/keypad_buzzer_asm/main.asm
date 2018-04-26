;
; keypad_buzzer_asm.asm
;
; Created: 19/4/2561 14:16:56
; Author : Warintorn
;

.INCLUDE "m328Pdef.inc"
.DEF TMP = r16
.DEF READ_V = r17
.DEF VAR_A = r18
.DEF DISTANCE = r19
.DEF TL = r20
.DEF TA = r21
.DEF TB = r22

.MACRO COMPARE_AND_BRANCH_IF_KEYPRESSED
	cpi VAR_A, 0xff
	brne KEYPRESSED
.ENDMACRO

.CSEG
.ORG 0x0000
	rjmp RESET

RESET:
	ldi TMP, 0x28
	out DDRB, TMP
	ldi TMP, 0x00
	out PORTB, TMP
	ldi TMP, 0xf0
	out DDRD, TMP

READ_KEY_PAD:
	;----- row A
	ldi TMP, 0b11101111
	ldi DISTANCE, 0
	call SCAN_KEYPAD
	COMPARE_AND_BRANCH_IF_KEYPRESSED
	
	;----- row B
	ldi TMP, 0b11011111
	ldi DISTANCE, 9
	call SCAN_KEYPAD
	COMPARE_AND_BRANCH_IF_KEYPRESSED

	;----- row C
	ldi TMP, 0b10111111
	ldi DISTANCE, 18
	call SCAN_KEYPAD
	COMPARE_AND_BRANCH_IF_KEYPRESSED

	;----- row D
	ldi TMP, 0b01111111
	ldi DISTANCE, 27
	call SCAN_KEYPAD
	COMPARE_AND_BRANCH_IF_KEYPRESSED
	
	ldi TMP, 0x00
	out PORTB, TMP
	rjmp READ_KEY_PAD

KEYPRESSED:
	call VOL_UP
	rjmp READ_KEY_PAD

VOL_UP:
	ldi TL, 0x28
	out PORTB, TL
	rcall _settime
	rcall _delay
	ldi TL, 0x00
	out PORTB, TL
	rcall _settime
	rcall _delay
	ret

_settime:
	ldi	TA, 0xff
	mov TB, VAR_A
	ret

_delay:
	dec TA
	brne _delay
	dec TB
	brne _delay
	ret

SCAN_KEYPAD:
	ldi		ZL, low(KEYPAD_TABLE*2)
	ldi		ZH, high(KEYPAD_TABLE*2)
	out		PORTD, TMP
	nop
	in		READ_V, PIND
	ldi		TMP, 0x0f
	and		READ_V, TMP
	add		READ_V, DISTANCE
	subi	READ_V, 7
	ldi		TMP, 0x00
	add		ZL, READ_V	
	adc		ZH, TMP
	lpm		VAR_A, Z
	ret

KEYPAD_TABLE:
	.DB 0x0f, 0xff, 0xff, 0xff, 0x10, 0xff, 0x11, 0x12, 0xff, 0x13, 0xff, 0xff, 0xff, 0x14, 0xff, 0x15, 0x16, 0xff 
	.DB 0x17, 0xff, 0xff, 0xff, 0x18, 0xff, 0x19, 0x1a, 0xff, 0x1b, 0xff, 0xff, 0xff, 0x1c, 0xff, 0x1d, 0x1e, 0xff
