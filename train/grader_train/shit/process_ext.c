#include "ruby.h"
#include <stdio.h>

static VALUE t_printit(VALUE self)
{
	printf("Hi\n");
	
	return self;
}

void Init_my_test() {
	VALUE cProcess = rb_gv_get("Process");
	rb_define_module_function(cProcess, "printIt", t_printit, 0);
}
