/*
 * HW1C.c
 *
 * Created: 4/4/2561 23:43:40
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 16000000
#include <util/delay.h>

unsigned char ROW, SWITCH_V;
void blink(unsigned char num, unsigned char p );

unsigned char LOOKUPTB[] = {
		0x01, 0xFF, 0xFF, 0xFF, 0x04, 0xFF, 0x07, 0x0A, 0xFF,
		0x02, 0xFF, 0xFF, 0xFF, 0x05, 0xFF, 0x08, 0x00, 0xFF,
		0x03, 0xFF, 0xFF, 0xFF, 0x06, 0xFF, 0x09, 0x0B, 0xFF
};

int main(void)
{
	DDRB = 0xF0;
	PORTB = 0x0F;
	DDRD = 0xFB;
	PORTD = 0xFF;
	EICRA = (1 << ISC01);	// Falling Edge Interrupt
	EIMSK = 1 << INT0;		// Enable INT0
	sei();
    while (1) 
    {
    }
}

ISR(INT0_vect)
{
	for(unsigned char i=0; i<3; i++)
	{
		PORTB = ~(1 << (6 - i));
		__asm__ __volatile__ ("nop");
		__asm__ __volatile__ ("nop");
		ROW = PINB & 0x0F;
		ROW = ROW - 7 + (i * 9);
		SWITCH_V = LOOKUPTB[ROW];
		if(SWITCH_V == 0x00)		blink(5, 0);
		else if(SWITCH_V != 0xFF)	blink(SWITCH_V, 1);
	}
	PORTB = 0x0F;
}

void blink(unsigned char num, unsigned char p )
{
	for(unsigned char i=0; i<num; i++)
	{
		PORTD ^= (0x01 << p);
		_delay_ms(300);
		PORTD ^= (0x01 << p);
		_delay_ms(300);
	}
}
