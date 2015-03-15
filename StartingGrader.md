# Introduction #

This page will help you to set up and run a Grader. The process right now is too complicated and need to be simplified. Please add your suggestions on how to do this here.


# Requirements #

  * Unix system
  * Copy of the source code of the Grader. It would be better if you can just download it from the svn. `svn co http://p-c-s.googlecode.com/svn/trunk/dev/grader/` is all you need.
  * SSH has to be enabled (it is used to copy files from the Storage)

# Setup #

  1. Compile the C extension.
```
cd grader/pcs/ext/
ruby extconf.rb
#
# If your distribution is based on Debian you may get the following error here:
# extconf.rb:1:in `require': no such file to load -- mkmf (LoadError)
#        from extconf.rb:1
# All you need to do is to install the pakage ruby<ruby version>-dev (ex. ruby1.8-dev for ruby version 1.8.*)
#
make
```

> 2. Edit the configuration file `config.rb`. You should change the content of the following lines to match you configuration. In production mode the grader will need a user with low privileges that will be used to execute the solutions. For testing purpose you can put your own user:

```
grader.execute_uid = 1000
grader.user = "borisof"
grader.grader_address = "127.0.0.1"
grader.grader_ssh_port = "22"
```

> 3. Follow this mini HOWTO to set up `scp` to work without password.
> > http://www.cs.umd.edu/~arun/misc/ssh.html


> 4. Start the Grader by `ruby start_grader.rb`

