#include<stdio.h>
#include<clib.h>

static void my_cb0(int val) { fprintf(stderr,"\\-CB0 %d\n",val); }
static void my_cb1(int val) { fprintf(stderr,"\\-CB1 %d\n",val); }
static void my_cb2(int val) { fprintf(stderr,"\\-CB2 %d\n",val); }
static int  my_cb3(int val) { fprintf(stderr,"\\-CB3 %d\n",val); return val*2; }
static CB1 my_cb4() { fprintf(stderr,"\\-CB4\n"); return my_cb3; }
static int  my_cb5(CB1 cb, int val) { fprintf(stderr,"\\-CB5 0x%X %d\n",cb,val); return cb(val); }
static int  my_cb6(int val) { fprintf(stderr," \\-CB6 %d\n",val); return val*2; }

int main(int argc, char* argv[], char* envp[])
{
    CB0 cb = 0;

    fprintf(stderr,"\n *** C callback\n");

    init(my_cb0,my_cb1);

    set_cb(my_cb0);
    call_cb();

    register_cb(66,my_cb0,-1);
    call_cb();

    register_cbs(69,my_cb1,666,my_cb2,-2);
    call_cbs();

    cb = get_cb(0);
    cb(6);
    cb = get_cb(1);
    cb(9);

    lookup_block_call_with_enum_arg(my_cb4, 2);
    lookup_block_call_with_enum_arg(my_cb4, 3);

    callback_call_with_callback_arg(my_cb5, my_cb6, 666);

	return 0;
}

