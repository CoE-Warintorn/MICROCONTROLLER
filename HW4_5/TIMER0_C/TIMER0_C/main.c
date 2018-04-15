/*
 * TIMER0_C.c
 *
 * Created: 14/4/2561 18:50:19
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

int main(void)
{
    DDRC	= 0x01;
	TIMSK0	= 0x01;	// Enable Overflow Interrupt
	TCCR0B	= 0x03; // clk div 64
	TCCR0A	= 0x00; // Normal mode
	TCNT0	= 189;
	sei();
    while (1) 
    {
    }
}

ISR(TIMER0_OVF_vect)
{
	TCNT0	= 189;
	PORTC	^= 0x01;
}

