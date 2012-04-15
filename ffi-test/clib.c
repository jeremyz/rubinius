

#include"clib.h"
#include<stdio.h>

static CB0 cb0_ = 0;
static CB0 cb1_ = 0;
static int a0_ = 0;
static int a1_ = 0;

void init (CB0 cb0, CB0 cb1) {
    cb0_ = cb0;
    cb1_ = cb1;
}

void set_value(int a0, int verbose) {
    if(verbose>0) fprintf(stderr,"|--CLIB : set value %d\n",a0);
    a0_ = a0;
}

int get_value(int verbose) {
    if(verbose>0) fprintf(stderr,"|--CLIB : get value %d\n",a0_);
    return a0_;
}

void set_cb (CB0 cb0) {
    fprintf(stderr,"|--CLIB : register callback 0x%X (void)\n",cb0);
    cb0_ = cb0;
    a0_ = 99;
}

CB0 get_cb(int a0) {
    fprintf(stderr,"|--CLIB : get_cb 0x%X\n",( a0==0 ? cb0_ : cb1_ ));
    return ( a0==0 ? cb0_ : cb1_ );
}

void register_cb (int a0, CB0 cb0, int a2) {
    fprintf(stderr,"|--CLIB : register callback 0x%X (%d)\n",cb0,a0);
    cb0_ = cb0;
    a0_ = a0;
}

void call_cb () {
    fprintf(stderr,"|--CLIB : call callback 0x%X\n",cb0_);
    cb0_(a0_);
}

void register_cbs (int a0, CB0 cb0, int a1, CB0 cb1, int a2) {
    fprintf(stderr,"|--CLIB : register callback 0x%X (%d)\n",cb0,a0);
    cb0_ = cb0;
    a0_ = a0;
    fprintf(stderr,"|--CLIB : register callback 0x%X (%d)\n",cb1,a1);
    cb1_ = cb1;
    a1_ = a1;
}

void call_cbs () {
    fprintf(stderr,"|--CLIB : call callback 0x%X (%d)\n",cb0_,a0_);
    cb0_(a0_);
    fprintf(stderr,"|--CLIB : call callback 0x%X (%d)\n",cb1_,a1_);
    cb1_(a1_);
}

int block_call_with_enum_arg(CB1 cb1, int val) {
    fprintf(stderr,"|--CLIB : block_call_with_enum_arg(0x%X, %d)\n",cb1,val);
    return (*cb1)(val);
}

int lookup_block_call_with_enum_arg(CB2 cb2, int val) {
    fprintf(stderr,"|--CLIB : lookup_block_call_with_enum_arg(0x%X,%d)\n",cb2,val);
    CB1 cb1 = cb2 ? (*cb2)() : NULL;
    fprintf(stderr,"  \\--CLIB : block_call_with_enum_arg(0x%X,%d)\n",cb1,val);
    return cb1 ? (*cb1)(val) : 0;
}

int callback_call_with_callback_arg(CB3 cb3, CB1 cb1, int val) {
    fprintf(stderr,"|--CLIB : callback_call_with_callback_arg(0x%X,0x%X,%d)\n",cb3,cb1,val);
    return (*cb3)(cb1,val);
}
