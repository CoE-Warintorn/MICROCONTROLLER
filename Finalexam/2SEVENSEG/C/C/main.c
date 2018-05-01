/*
 * C.c
 *
 * Created: 1/5/2561 2:24:30
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
void read_show_switch();
unsigned char tmp, ten, one;
unsigned char LOOKUPTB[] = {
	0b00111111, 0b00000110, // 0, 1
	0b01011011, 0b01001111, // 2, 3
	0b01100110, 0b01101101, // 4, 5
	0b01111101, 0b00000111, // 6, 7
	0b01111111, 0b01101111, // 8, 9
	0b01110111, 0b01111100, // A, b
	0b01011000, 0b01011110, // c, d
	0b01111001, 0b01110001  // E, F
	};

int main(void)
{
    DDRC = 0xFF;
	DDRD = 0xFF;
	DDRB = 0xC1;
	PORTB = 0x3E;
	read_show_switch();
	PCICR = 0x01;
	PCMSK0 = 0x3E;
	sei();
	
    while (1) 
    {
    }
}

void read_show_switch()
{
	tmp = (PINB >> 1) & 0x1F;
	one = tmp % 10;
	ten = tmp / 10;
	PORTD = ~LOOKUPTB[one];
	PORTC = ~LOOKUPTB[ten];
}

ISR(PCINT0_vect)
{
	read_show_switch();
}