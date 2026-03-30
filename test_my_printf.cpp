#include <stdio.h>
#include <math.h>

extern "C" void _my_printf_(...) __attribute__((format(printf, 1, 2))); 

int main()
{

	_my_printf_("%d\n%d\n%s:%d\n%s:%b\n%x\n%c\n%%333\n", 13, 13, "hahahaha", 17, "uaaaaaaaaaa", 18, 26, 'B');
	_my_printf_("meow\n%d\n", 12321);
	_my_printf_("%s %s %s %s %s %s\n", "meow1", "meow2", "meow3", "meow4", "meow5", "meow6"); 
	_my_printf_(" %f %f %f %f %f %f %f :%f %f %d %d %d %d %d %c %f %f %f %d\n", -0.127, 123.0 , 777.888, 1.6, 1.7, 1.8, 1.9, 2.0, 0.9, 12, 13, 14, 15, 16, 'B', 1.5, 1.75, 2.0, 13); 
	_my_printf_("%f\n", 1.750); 
	_my_printf_("%s\n", "qwertyuiop[]asdfghjkl;'zxcvbnm,./1qwertyuiop[]asdfghjkl;'zxcvbnm,./2qwertyuiop[]asdfghjkl;'zxcvbnm,./3qwertyuiop[[asdfghjkl;'zxcvbnm,./4qwertyuiop[]asdfghjkl;'zxcvbnm,./5qwertyuiop[]asdfghjkl;'zxcvbnm,./6qwertyuiop[]asdfghjkl;'zxcvbnm,./7qwertyuiop[]asdfghjkl;'zxcvbnm,./8qwertyuiop[asdfghjkl;'zxcvbnm,.9qwertyuiop[]asdfghjkl;'zxcvbnm,./10i[qqwertyuiop[]asdfghjkl;'zxcvbnm,./1qwertyuiop[]asdfghjkl;'zxcvbnm,./2qwertyuiop[]asdfghjkl;'zxcvbnm,./3qwertyuiop[[asdfghjkl;'zxcvbnm,./4qwertyuiop[]asdfghjkl;'zxcvbnm,./5qwertyuiop[]asdfghjkl;'zxcvbnm,./6qwertyuiop[]asdfghjkl;'zxcvbnm,./7qwertyuiop[]asdfghjkl;'zxcvbnm,./8qwertyuiop[asdfghjkl;'zxcvbnm,.9qwertyuiop[]asdfghjkl;'zxcvbnm,./10i[wertyuiop[]asdfghjkl;'zxcvbnm,./1qwertyuiop[]asdfghjkl;'zxcvbnm,./2qwertyuiop[]asdfghjkl;'zxcvbnm,./3qwertyuiop[[asdfghjkl;'zxcvbnm,./4qwertyuiop[]asdfghjkl;'zxcvbnm,./5qwertyuiop[]asdfghjkl;'zxcvbnm,./6qwertyuiop[]asdfghjkl;'zxcvbnm,./7qwertyuiop[]asdfghjkl;'zxcvbnm,./8qwertyuiop[asdfghjkl;'zxcvbnm,.9qwertyuiop[]asdfghjkl;'zxcvbnm,./10i[wertyuiop[]asdfghjkl;'zxcvbnm,./1qwertyuiop[]asdfghjkl;'zxcvbnm,./2qwertyuiop[]asdfghjkl;'zxcvbnm,./3qwertyuiop[[asdfghjkl;'zxcvbnm,./4qwertyuiop[]asdfghjkl;'zxcvbnm,./5qwertyuiop[]asdfghjkl;'zxcvbnm,./6qwertyuiop[]asdfghjkl;'zxcvbnm,./7qwertyuiop[]asdfghjkl;'zxcvbnm,./8qwertyuiop[asdfghjkl;'zxcvbnm,.9qwertyuiop[]asdfghjkl;'zxcvbnm,./10i[");


	printf("--------------------------------------------------\n");
	_my_printf_("%d\n%d\n%s:%d\n%s:%d\n%x\n%c\n333\n"
	       "%d %s %x %% %c %d %f %f\n",
	       13, 13, "hahahaha", 17, "uaaaaaaaaaa", 18, 26, 'B',
	       -1, "love", 3802, 33, 162, 2.7919, 1.0/0.0
	      );
	printf("--------------------------------------------------\n");

	_my_printf_("%d\n", 10);
	//printf("%f\n", 18.125123111);
//	printf("%x\n", -12); 
//	printf("Hell
//	_my_printf_("%%\n333\n", 'A') %f ;
	return 0;
}

int mmain()
{
	//_my_printf_("%d %s %f %f %f %f %f %f\n", 10, "love", 1.371, 1.78, NAN, 1.0/0.0, 1.96, 2.15);
	_my_printf_("%x %f %f\n", 4802, 2.75, 1.0/0.0);
	return 0;
}
