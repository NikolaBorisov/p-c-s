# Introduction #

This page gives details how to start the storage server.


# Requirements #

  * svn or copy of the source code for the Storage
  * access to the Database
  * scp setup to copy files to remote computers (Graders) without password. (see [StartingGrader](StartingGrader.md))
  * Unix based OS
  * Ruby 1.8

# Steps #

  1. Checkout the source code `svn co http://p-c-s.googlecode.com/svn/trunk/dev/storage/`
  1. Edit the config file to configure the location of the Database and other stuff.
  1. `ruby start_storage.rb`

