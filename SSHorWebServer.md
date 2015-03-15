# Introduction #

In the current implementation the applications use scp to copy files between computers. For example the Grader request some files by calling an web service on the Storage Server and giving him the host name and the port on which the ssh server is running on the Grader. Then the Storage Server uses scp to copy the file to some place in the Grader.


# Using SCP #

## Good Sides ##

  * it is build in Unix like OS
  * it uses encription when copying the files.

## Bad Sides ##

  * setting up scp work without passwords makes installation on new machines difficult
  * scp is platform specific (Unix only)
  * the Storage server is pushing the file to the Graders where a Pulling approach may scale  better.

# The proposed approach Using WebServer #

A different approach to the problem could be to run a simple static web server on the Storage module of the application. When Graders request resources the Storage server will just point them to the correct url where they can download the files they need.

## Good Sides ##

  * it is doesn't require configuration on the OS level to work
  * may improve performance.
  * could be more stable because Graders have to download files which should be more trivial.
  * Graders will just request the url with webservice calls and will do the download on their own.

## Bad Sides ##

  * have work on security issues to protect the files from downloading by someone else.
  * an web server have to work with the Storage Server.
  * involves changing something that works now.

# Should we change this? #