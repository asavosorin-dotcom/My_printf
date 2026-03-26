#include <stdio.h>

extern "C" void _my_printf_(...) ; 

int main()
{
	//_my_printf_("%d\n%d\n%s:%d\n%s:%b\n%x\n%c\n%%333\n", 13, 13, "hahahaha", 17, "uaaaaaaaaaa", 18, 26, 'B', 14);
	//_my_printf_("meow\n%d\n", 12321);
	_my_printf_("%f [%s] %d %d %d\n", 0.127, "meow", 15, 16, 17); 
	//printf("%f\n", 18.125123111);
//	printf("%x\n", -12); 
//	printf("Hell
//	_my_printf_("%%\n333\n", 'A');
	return 0;
}
