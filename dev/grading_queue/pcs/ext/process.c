#include "ruby.h"
#include "rubysig.h"
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>



#define RLIM2NUM(v) UINT2NUM(v)
#define NUM2RLIM(v) NUM2UINT(v)



extern VALUE rb_last_status;



static VALUE create_status(int status, int pid)
{
	VALUE rb_mProcess = rb_define_module("Process");
	VALUE rb_cProcStatus = rb_define_class_under(rb_mProcess, "Status", rb_cObject);

    VALUE process_status = rb_obj_alloc(rb_cProcStatus);
    rb_iv_set(process_status, "status", INT2FIX(status));
    rb_iv_set(process_status, "pid", INT2FIX(pid));

	return process_status;
}


int my_rb_wait4(int pid, int *st, int flags, struct rusage *rusage)
{
    int result;
    int oflags = flags;

    if (!rb_thread_alone())
    {
    	flags |= WNOHANG;
    }

  retry:
    TRAP_BEG;
    result = wait4(pid, st, flags, rusage);
    TRAP_END;

    if (result < 0)
    {
	    if (errno == EINTR)
        {
	        rb_thread_polling();
	        goto retry;
	    }

	    return -1;
    }

    if (result == 0)
    {
	    if (oflags & WNOHANG)
        {
            return 0;
        }

	    rb_thread_polling();

	    if (rb_thread_alone())
        {
            flags = oflags;
        }

	    goto retry;
    }

    return result;
}


static VALUE rusage2hash(struct rusage *rusage)
{
    VALUE hash = rb_hash_new();
    VALUE key, value;

    key = rb_str_intern(rb_str_new2("ru_utime_sec"));
    value = UINT2NUM(rusage->ru_utime.tv_sec);
    rb_hash_aset(hash, key, value);

    key = rb_str_intern(rb_str_new2("ru_utime_usec"));
    value = UINT2NUM(rusage->ru_utime.tv_usec);
    rb_hash_aset(hash, key, value);

    key = rb_str_intern(rb_str_new2("ru_stime_sec"));
    value = UINT2NUM(rusage->ru_stime.tv_sec);
    rb_hash_aset(hash, key, value);

    key = rb_str_intern(rb_str_new2("ru_stime_usec"));
    value = UINT2NUM(rusage->ru_stime.tv_usec);
    rb_hash_aset(hash, key, value);

    return hash;
}


static VALUE proc_wait4(int argc, VALUE *argv)
{
    VALUE vpid, vflags;
    int pid, flags, status;
    struct rusage rusage;

    rb_secure(2);
    flags = 0;
    rb_scan_args(argc, argv, "02", &vpid, &vflags);

    if (argc == 0)
    {
    	pid = -1;
    }
    else
    {
	    pid = NUM2INT(vpid);
	    if (argc == 2 && !NIL_P(vflags))
        {
	        flags = NUM2UINT(vflags);
	    }
    }

    if ((pid = my_rb_wait4(pid, &status, flags, &rusage)) < 0)
    {
	    rb_sys_fail(0);
    }

	rb_last_status = Qnil;

	VALUE process_status = create_status(status, pid);
	VALUE usage = rusage2hash(&rusage);

    return rb_assoc_new(process_status, usage);
}


static VALUE proc_getrlimit(VALUE obj, VALUE resource)
{
    struct rlimit rlim;

    rb_secure(2);

    if (getrlimit(NUM2INT(resource), &rlim) < 0)
    {
        rb_sys_fail("getrlimit");
    }

    return rb_assoc_new(RLIM2NUM(rlim.rlim_cur), RLIM2NUM(rlim.rlim_max));
}


static VALUE proc_setrlimit(int argc, VALUE *argv, VALUE obj)
{
    VALUE resource, rlim_cur, rlim_max;
    struct rlimit rlim;

    rb_secure(2);

    rb_scan_args(argc, argv, "21", &resource, &rlim_cur, &rlim_max);
    if (rlim_max == Qnil)
    {
        rlim_max = rlim_cur;
    }

    rlim.rlim_cur = NUM2RLIM(rlim_cur);
    rlim.rlim_max = NUM2RLIM(rlim_max);

    if (setrlimit(NUM2INT(resource), &rlim) < 0)
    {
        rb_sys_fail("setrlimit");
    }

    return Qnil;
}


static VALUE proc_getrusage(VALUE obj, VALUE who_value)
{
    struct rusage rusage;
    getrusage(NUM2INT(who_value), &rusage);

    return rusage2hash(&rusage);
}


void Init_process(void)
{
    VALUE rb_mProcess = rb_define_module("Process");

    rb_define_module_function(rb_mProcess, "getrlimit", proc_getrlimit, 1);
    rb_define_module_function(rb_mProcess, "setrlimit", proc_setrlimit, -1);
    rb_define_module_function(rb_mProcess, "getrusage", proc_getrusage, 1);
    rb_define_module_function(rb_mProcess, "wait4", proc_wait4, -1);

    rb_define_const(rb_mProcess, "RLIMIT_CORE", INT2FIX(RLIMIT_CORE));
    rb_define_const(rb_mProcess, "RLIMIT_CPU", INT2FIX(RLIMIT_CPU));
    rb_define_const(rb_mProcess, "RLIMIT_DATA", INT2FIX(RLIMIT_DATA));
    rb_define_const(rb_mProcess, "RLIMIT_FSIZE", INT2FIX(RLIMIT_FSIZE));
    rb_define_const(rb_mProcess, "RLIMIT_NOFILE", INT2FIX(RLIMIT_NOFILE));
    rb_define_const(rb_mProcess, "RLIMIT_STACK", INT2FIX(RLIMIT_STACK));
    rb_define_const(rb_mProcess, "RLIMIT_AS", INT2FIX(RLIMIT_AS));
    rb_define_const(rb_mProcess, "RLIMIT_MEMLOCK", INT2FIX(RLIMIT_MEMLOCK));
    rb_define_const(rb_mProcess, "RLIMIT_NPROC", INT2FIX(RLIMIT_NPROC));
    rb_define_const(rb_mProcess, "RLIMIT_RSS", INT2FIX(RLIMIT_RSS));
    rb_define_const(rb_mProcess, "RUSAGE_SELF", INT2FIX(RUSAGE_SELF));
    rb_define_const(rb_mProcess, "RUSAGE_CHILDREN", INT2FIX(RUSAGE_CHILDREN));
}
