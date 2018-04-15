/*
 * TIMER1_C_CTC.c
 *
 * Created: 15/4/2561 17:15:58
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

int main(void)
{
	DDRC	= 0x01;	// set PC0 as output
	TIMSK1	= 0x02;	// compare match A interrupt enable
	TCCR1B	= 0x09;	// No prescaler
	TCCR1A	= 0x00;	// CTC mode
	cli();
	TCNT1	= 0;
	OCR1A	= 3571;
	sei();
	while (1)
	{
	}
}

ISR(TIMER1_COMPA_vect)
{
	PORTC ^= 0x01;
}
