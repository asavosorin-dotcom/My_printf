#include <stdio.h>

extern "C" void _my_printf_(...)  __attribute__((cdecl));

int main()
{
	 _my_printf_("%s:%d\n%s:%b\n%x\n%o\n%d\n%d\n", "hahahaha", 17, "uaaaaaaaaaa", 18, 26, 13, 14, 15);
//	printf("Hell
	return 0;
}
