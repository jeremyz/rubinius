
typedef void(*CB0)(int val);
typedef  int(*CB1)(int val);
typedef  CB1(*CB2)();
typedef  int(*CB3)(CB1, int val);

void init (CB0 cb0, CB0 cb1);

void set_value(int a0, int verbose);
int get_value(int verbose);

void set_cb (CB0 cb);
CB0 get_cb(int a0);

void register_cb (int a0, CB0 cb, int a2);
void call_cb ();

void register_cbs (int a0, CB0 cb0, int a1, CB0 cb1, int a2);
void call_cbs ();

int block_call_with_enum_arg(CB1 cb1, int val);
int lookup_block_call_with_enum_arg(CB2 cb2, int val);

int callback_call_with_callback_arg(CB3 cb3, CB1 cb1, int val);
