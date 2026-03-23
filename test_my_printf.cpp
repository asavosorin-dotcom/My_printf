#include <stdio.h>

extern "C" void _my_printf_(...) ; 

int main()
{
	_my_printf_("%s:%d\n%s:%b\n%x\n%c\n%%333\n", "hahahaha", 17, "uaaaaaaaaaa", 18, 26, 'B', 14);
	_my_printf_("meow\n%d\n", 12321);
	_my_printf_("%d\n%d\n", 1, -1);
//	printf("%x\n", -12); 
//	printf("Hell
//	_my_printf_("%%\n333\n", 'A');
	return 0;
}
