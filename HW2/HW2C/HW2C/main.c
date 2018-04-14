/*
 * HW2C.c
 *
 * Created: 11/4/2561 22:51:41
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 16000000
#include <util/delay.h>

unsigned char LOOKUPTB[] = {
	//	DDRC	PORTC
	0b1111011, 0b0000010,	//	LED 1
	0b1111011, 0b0000001,	//	LED 2
	0b1111110, 0b0000100,	//	LED 3
	0b1111110, 0b0000010,	//	LED 4
	0b1111101, 0b0000100,	//	LED 5
	0b1111101, 0b0000001	//	LED 6
};

unsigned char SWITCH_V, i, test_bit;

int main(void)
{
	DDRB	= 0xC0;
	PORTB	= 0x3F;
	SWITCH_V = PINB;
	// Set Pin Change Interrupt 
    PCICR	= 0x01;
	PCMSK0	= 0x3F;
	sei();
    while (1) 
    {
		if(SWITCH_V)
		{
			for(i=0; i<6; i++)
			{
				test_bit = SWITCH_V & (1 << i);
				if(test_bit)
				{
					DDRC	= LOOKUPTB[2*i];
					PORTC	= LOOKUPTB[2*i + 1];
					_delay_ms(7);
				}
			}
		}
		else
		{
			DDRC	= 0xFF;
			PORTC	= 0x00;
		}
    }
}

ISR(PCINT0_vect)
{
	SWITCH_V = PINB;
}