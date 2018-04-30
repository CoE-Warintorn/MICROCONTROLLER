/*
 * 2Pulse_C.c
 *
 * Created: 1/5/2561 0:32:58
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

int main(void)
{
	DDRC = 0x03;	// Initial PortC as Output
	PORTC = 0x00;
	
	TCNT1 = 0;
	OCR1A = 19999;	// Pulse 1
	OCR1B = 10000;	// Pulse 2 diff 90
	TCCR1A = 0x00;	// Set CTC mode
	TCCR1B = 0x0A;	// clock / 8
	TIMSK1 = 0x06;	// Enable CompA and CompB
	
	sei();
	while (1)
	{
	}
}

ISR(TIMER1_COMPA_vect)
{
	PORTC ^= 0x01;
}

ISR(TIMER1_COMPB_vect)
{
	PORTC ^= 0x02;
}

