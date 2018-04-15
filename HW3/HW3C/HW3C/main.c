/*
 * HW3C.c
 *
 * Created: 14/4/2561 9:17:25
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 16000000
#include <util/delay.h>

unsigned char COUNT;
uint16_t TIMER;
unsigned char LOOKUPTB[] = {
	0b00111111,	0b00000110, // 0, 1
	0b01011011,	0b01001111, // 2, 3
	0b01100110,	0b01101101, // 4, 5
	0b01111101,	0b00000111, // 6, 7
	0b01111111,	0b01101111, // 8, 9
	0b01110111,	0b01111100, // A, b
	0b00111001,	0b01011110, // c, d
	0b01111001,	0b01110001	// E, F
};

int main(void)
{
    DDRB	= 0xFF;
	PORTB	= LOOKUPTB[0];
	DDRD	= 0xFB;
	PORTD	= 0x04;
	COUNT	= 0;
	
	EICRA	= 0x02; // Falling Edge Interrupt
	EIMSK	= 0x01;	// Enable INT0
	sei();			// Enable Interrupt
    while (1) 
    {
		
    }
}

ISR(INT0_vect)
{
	TIMER = 0;
	while( !(PIND & 0x04) && TIMER < 3000)
	{
		_delay_ms(1);
		PORTB ^= 0x80; // Check 3 Sec
		TIMER++;
	}
	
	if(TIMER==3000)
	{
		COUNT = 0;
	}
	else
	{
		COUNT++;
		if(COUNT==16)
			COUNT = 0;
	}
	PORTB	= LOOKUPTB[COUNT];
}