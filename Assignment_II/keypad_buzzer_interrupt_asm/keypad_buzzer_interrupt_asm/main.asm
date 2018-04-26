;
; keypad_buzzer_interrupt_asm.asm
;
; Created: 19/4/2561 22:16:13
; Author : Warintorn
;

.INCLUDE "m328pdef.inc"
.DEF	tmp		= r16
.DEF	distance= r17
.DEF	row		= r18
.DEF	col		= r19
.DEF	value	= r20
.DEF	TA		= r21
.DEF	TB		= r22
.DEF	TC		= r23

.CSEG
.ORG	0x00
	jmp		start
	jmp		INT0_handler


start:
	; SETUP STACK POINTER
	ldi		tmp, low(RAMEND)  
	out		SPL, tmp
	ldi		tmp, high(RAMEND)
	out		SPH, tmp

	; PORTD
	; 7, 5, 4, 3 OUTPUT row scan
	; 2 INPUT INT0 interrupt
	; 6 OUTPUT OC0A
	ldi		tmp, 0xFB
	out		DDRD, tmp
	ldi		tmp, 0x04
	out		PORTD, tmp

	; PORTB 3, 2, 1, 0 INPUT column read
	ldi		tmp, 0xF0
	out		DDRB, tmp
	ldi		tmp, 0x0F
	out		PORTB, tmp

	; SETUP INTERRUPT
	ldi		tmp, 0x01
	sts		EICRA, tmp
	out		EIMSK, tmp

	; SETUP TIMER0
	ldi		tmp, 0
	out		TCNT0, tmp
	out		OCR0A, tmp			
	ldi		tmp, 0b01000010;
	out		TCCR0A, tmp			; CTC mode
	ldi		tmp, 0b00000000;
	out		TCCR0B, tmp			; First no source clk
	ldi		tmp, 0x00
	sts		TIMSK0, tmp			; Disable Timer0 ComMatchA Interrupt
	
	sei
main:
	rjmp	main

.MACRO DELAY_500ms
	ldi		TC, 0x1E
LC:	ldi		TB, 0xFF
LB: ldi		TA, 0xFF
LA:	dec		TA
	brne	LA
	dec		TB
	brne	LB
	dec		TC
	brne	LC
.ENDMACRO

.MACRO KEYPRESSED
	out		OCR0A, value
	ldi		tmp, 0b00000100;	; Set CLK/256
	out		TCCR0B, tmp
	ldi		tmp, 0x02
	sts		TIMSK0, tmp			; Enable Timer0 ComMatchA Interrupt
.ENDMACRO

.MACRO SCAN
	ldi		ZL, low(LOOKUPTB * 2)
	ldi		ZH, high(LOOKUPTB * 2)
	out		PORTD, row
	nop
	nop
	in		col, PINB
	andi	col, 0x0F
	add		col, distance
	ldi		tmp, 0x00
	subi	col, 0x07
	add		ZL, col
	adc		ZH, tmp
	lpm		value, Z
.ENDMACRO

.MACRO READ_KEY_PAD
ROW1:
	ldi		row, 0b11110111
	ldi		distance, 0
	SCAN
	cpi		value, 0xFF
	breq	ROW2
	KEYPRESSED
	rjmp	Finish

ROW2:
	ldi		row, 0b11101111
	ldi		distance, 9
	SCAN
	cpi		value, 0xFF
	breq	ROW3
	KEYPRESSED
	rjmp	Finish

ROW3:
	ldi		row, 0b11011111
	ldi		distance, 18
	SCAN
	cpi		value, 0xFF
	breq	ROW4
	KEYPRESSED
	rjmp	Finish

ROW4:
	ldi		row, 0b01111111
	ldi		distance, 27
	SCAN
	cpi		value, 0xFF
	breq	OFF
	KEYPRESSED
	rjmp	Finish

OFF:
	ldi		tmp, 0b00000000;	; Set CLK OFF
	out		TCCR0B, tmp
	ldi		tmp, 0x00
	sts		TIMSK0, tmp			; Disable Timer0 ComMatchA Interrupt

Finish:
.ENDMACRO
	

INT0_handler:
	push	tmp
	in		tmp, SREG
	push	tmp

	READ_KEY_PAD
	ldi		tmp, 0x04
	out		PORTD, tmp

	pop		tmp
	out		SREG, tmp
	pop		tmp
	reti

LOOKUPTB:
	.DB		118, 0xFF, 0xFF, 0xFF, 105, 0xFF, 93, 89, 0xFF, 79, 0xFF, 0xFF, 0xFF, 70, 0xFF, 62, 59, 0xFF
	.DB		52, 0xFF, 0xFF, 0xFF, 46, 0xFF, 44, 39, 0xFF, 35, 0xFF, 0xFF, 0xFF, 31, 0xFF, 29, 26, 0xFF