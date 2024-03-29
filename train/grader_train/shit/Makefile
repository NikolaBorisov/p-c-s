
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = C:/dev/Ruby/Interpretator/ruby/lib/ruby/1.8/i386-mswin32
hdrdir = $(topdir)
VPATH = $(srcdir);$(topdir);$(hdrdir)

DESTDIR = C:
prefix = $(DESTDIR)/dev/Ruby/Interpretator/ruby
exec_prefix = $(prefix)
sitedir = $(prefix)/lib/ruby/site_ruby
rubylibdir = $(libdir)/ruby/$(ruby_version)
top_srcdir = $(DESTDIR)/develop/win/ruby/ruby-1.8.4
archdir = $(rubylibdir)/$(arch)
sbindir = $(exec_prefix)/sbin
datadir = $(prefix)/share
includedir = $(prefix)/include
infodir = $(prefix)/info
sysconfdir = $(prefix)/etc
mandir = $(prefix)/man
libdir = $(exec_prefix)/lib
sharedstatedir = $(DESTDIR)/etc
oldincludedir = $(DESTDIR)/usr/include
sitearchdir = $(sitelibdir)/$(sitearch)
localstatedir = $(DESTDIR)/var
bindir = $(exec_prefix)/bin
sitelibdir = $(sitedir)/$(ruby_version)
libexecdir = $(exec_prefix)/libexec

CC = cl -nologo
LIBRUBY = $(RUBY_SO_NAME).lib
LIBRUBY_A = $(RUBY_SO_NAME)-static.lib
LIBRUBYARG_SHARED = $(LIBRUBY)
LIBRUBYARG_STATIC = $(LIBRUBY_A)

CFLAGS   =  -MD -Zi -O2b2xg- -G6 
CPPFLAGS = -I. -I$(topdir) -I$(hdrdir) -I$(srcdir)  
CXXFLAGS = $(CFLAGS) 
DLDFLAGS =  -link -incremental:no -debug -opt:ref -opt:icf -dll $(LIBPATH) -def:$(DEFFILE) -implib:$(*F:.so=)-$(arch).lib -pdb:$(*F:.so=)-$(arch).pdb 
LDSHARED = cl -nologo -LD
AR = lib -nologo
EXEEXT = .exe

RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = msvcrt-ruby18
arch = i386-mswin32
sitearch = i386-msvcrt
ruby_version = 1.8
ruby = C:/dev/Ruby/Interpretator/ruby/bin/ruby
RUBY = $(ruby:/=\)
RM = $(RUBY) -run -e rm -- -f
MAKEDIRS = @$(RUBY) -run -e mkdir -- -p
INSTALL = copy > nul
INSTALL_PROG = $(INSTALL)
INSTALL_DATA = $(INSTALL)
COPY = copy > nul

#### End of system configuration section. ####

preload = 

libpath = $(libdir)
LIBPATH =  -libpath:"$(libdir)"
DEFFILE = $(TARGET)-$(arch).def

CLEANFILES = 
DISTCLEANFILES = vc*.pdb $(DEFFILE)

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED)  oldnames.lib user32.lib advapi32.lib wsock32.lib  
SRCS = process_ext.c compiler.cpp run.cpp
OBJS = process_ext.obj compiler.obj run.obj
TARGET = process_ext
DLLIB = $(TARGET).so
STATIC_LIB = 

RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR    = $(sitelibdir)$(target_prefix)
RUBYARCHDIR   = $(sitearchdir)$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).so $(TARGET).il? $(TARGET).tds $(TARGET).map
CLEANOBJS     = *.obj *.lib *.s[ol] *.pdb *.exp *.bak

all:		$(DLLIB)
static:		$(STATIC_LIB)

clean:
		@-$(RM) $(CLEANLIBS:/=\) $(CLEANOBJS:/=\) $(CLEANFILES:/=\)

distclean:	clean
		@-$(RM) Makefile extconf.h conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES:/=\)

realclean:	distclean
install: install-so install-rb

install-so: $(RUBYARCHDIR)
install-so: $(RUBYARCHDIR)/$(DLLIB)
$(RUBYARCHDIR)/$(DLLIB): $(DLLIB)
	$(INSTALL_PROG) $(DLLIB:/=\) $(RUBYARCHDIR:/=\)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
$(RUBYARCHDIR):
	$(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .cxx .cpp .obj

{$(srcdir)}.cc{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(topdir)}.cc{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(hdrdir)}.cc{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

.cc.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(srcdir)}.cxx{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(topdir)}.cxx{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(hdrdir)}.cxx{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

.cxx.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(srcdir)}.cpp{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(topdir)}.cpp{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(hdrdir)}.cpp{}.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

.cpp.obj:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -Tp$(<:\=/)

{$(srcdir)}.c{}.obj:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -Tc$(<:\=/)

{$(topdir)}.c{}.obj:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -Tc$(<:\=/)

{$(hdrdir)}.c{}.obj:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -Tc$(<:\=/)

.c.obj:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -Tc$(<:\=/)

$(DLLIB): $(DEFFILE) $(OBJS)
	@-$(RM) $@
	$(LDSHARED) -Fe$(@) $(OBJS) $(LIBS) $(LOCAL_LIBS) $(DLDFLAGS)



$(DEFFILE): 
	$(RUBY) -e "puts 'EXPORTS', 'Init_$(TARGET)'"  > $@

$(OBJS): {.;$(srcdir);$(topdir);$(hdrdir)}ruby.h {.;$(srcdir);$(topdir);$(hdrdir)}defines.h
