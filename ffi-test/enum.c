#include<stdio.h>
#include<clib.h>

static void my_cb0(int val) { fprintf(stderr,"\\-CB0 %d\n",val); }
static void my_cb1(int val) { fprintf(stderr,"\\-CB1 %d\n",val); }
static int  my_cb2(int val) { fprintf(stderr,"\\-CB2 %d\n",val); return val*2; }

int main(int argc, char* argv[], char* envp[])
{
    fprintf(stderr,"\n *** C enum\n");

    init(my_cb0,my_cb1);

    set_value(6,1);
    get_value(1);

    set_value(9,1);
    get_value(1);

    fprintf(stderr,"|-- %d\n",block_call_with_enum_arg(my_cb2, 2));
    fprintf(stderr,"|-- %d\n",block_call_with_enum_arg(my_cb2, 3));

	return 0;
}

