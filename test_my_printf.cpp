#include <stdio.h>

extern "C" void _my_printf_(...)  __attribute__((cdecl));

int main()
{
	_my_printf_("%s:%d\n%s:%b\n%x\n%c\n%%333\n", "hahahaha", 17, "uaaaaaaaaaa", 18, 26, 'B', 14);
//	printf("Hell
	//_my_printf_("%%\n333\n", 'A');
	return 0;
}
