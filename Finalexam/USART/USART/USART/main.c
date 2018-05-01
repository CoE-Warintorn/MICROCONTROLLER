/*
 * USART.c
 *
 * Created: 1/5/2561 12:19:58
 * Author : Warintorn
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

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
	// Setup 7 segment
	DDRC = 0xFF;
	// Setup USART
	UCSR0A = 0x00;
	UCSR0B = (1 << RXCIE0) | (1 << RXEN0);
	UCSR0C = (1 << USBS0) | (3 << UCSZ00);
	UBRR0 = 34;
	sei();
    while (1) 
    {
    }
}

ISR(USART_RX_vect)
{
	char c = UDR0;
	switch(c) {
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
		PORTC = ~LOOKUPTB[c-'0'];
		break;
		default:
		PORTC = ~LOOKUPTB[0x0E];
	}
}