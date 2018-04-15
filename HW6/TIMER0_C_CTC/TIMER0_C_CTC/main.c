/*
 * TIMER0_C_CTC.c
 *
 * Created: 15/4/2561 15:47:44
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

int main(void)
{
    DDRC	= 0x01;	// set PC0 as output
	TIMSK0	= 0x02;	// compare match A interrupt enable
	TCCR0B	= 0x03;	// clk div by 64
	TCCR0A	= 0x02;	// CTC mode
	TCNT0	= 0;
	OCR0A	= 55;
	sei();
    while (1) 
    {
    }
}

ISR(TIMER0_COMPA_vect)
{
	PORTC ^= 0x01;
}
