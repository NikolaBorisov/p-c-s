# Introduction #

This page will go over the basic staff that you need to setup before starting to develop the  PCS. Here we will show one way to prepare your machine. Feel free to use other software according to your preference.

# Ruby and Rails #

You will need ruby1.8 and rails 1.2.3. The way to install them in Ubuntu is
```
sudo apt-get install ruby rubygems ri rdoc rake ruby1.8-dev libyaml-ruby libzlib-ruby
```
Then to install the correct version of rails do:
```
sudo gem install rails -v 1.2.3
```


# Eclipse #

One very good IDE to use if you want to develop code for PCS is Eclipse. You can always use a basic Eclipse and install additional plugins for Ruby and Ruby on Rails. A better solution is EasyEclipse a modified version of eclipse with pre-installed plugins. So you can download the EasyEclipse specified in Ruby development from [here](here.md).

# Subversion #

The PCS code is stored in a SVN. If you have never used source version control system please take some time to familiarize youself with SVN (a good tutorial can be found  [here](http://www-128.ibm.com/developerworks/opensource/library/os-ecl-subversion/). There is a subversion client for Eclipse named Subclipse http://subclipse.tigris.org/. Please follow the installation instructions http://subclipse.tigris.org/install.html to install Subclipse in your Eclipse. This is already installed if you use EasyEclipse.

# Checkout The Project Tree #

After you have installed the Subclipse plugin, you should do:

  * File -> Import
  * Import Project from SVN
  * enter the following url https://p-c-s.googlecode.com/svn/
  * When prompted enter you password for code.google.com (not for your gmail) http://code.google.com/hosting/settings
  * Use the new project wizard and select Ruby project.

# MYSQL #

You also need to install MYSQL on your computer or use it from another computer. To do this you should be familiar first with Rails. After a row installation of Mysql run the following
```
mysql -u root -p
```
now load the sql script that creates an user and databases. The script is located in the source tree.
```
source dev/main/db/create_user_db.sql
```
If you install first Rails then it doesn't know where is the mysql socket so run the following to make Rails happy.
```
sudo ln -s /var/run/mysqld/mysqld.sock /tmp/mysql.sock
```
Now we have to migrate the the DB to the latest version. Execute the following in the root of the Rails project (dev/main)
```
rake db:migrate
```
Please make yourself familiar with the Rails migration infrastructure.

# Conclusion #

This should be everything you need to setup you environment.

# Problems? #

Please report problem and add your own experience and suggestions to this page.