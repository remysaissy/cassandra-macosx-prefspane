cassandra-macosx-prefspane
========================

This is a Preferences pane for Cassandra.

![Screenshot](https://github.com/remysaissy/cassandra-macosx-prefspane/raw/master/doc/screenshot%20started.png)

Functionalities
---------------

* Runs on MacOSX Snow Leopard, Lion as well as Moutain Lion
* Indicates if the server is running
* Manual start/stop of the Cassandra server
* Enable/disable automatic startup of the server at login
* Automatic update, new versions install automatically
* A green label at the top right corner informs you that you should restart your system preferences
* Works with homebrew
* Works with the Apache distribution of Cassandra (as long as you have a symbolic link of cassandra binary to ~/bin)

Localization
------------

* English
* French
* Simplified Chinese
* Spanish
* Brazilian / Portugese

Prerequisites
-------------

It does not embed a Cassandra Server. Therefore, you first have to install Cassandra.
A simple way to do it is by using Homebrew to install Cassandra.
Another way is to download Cassandra from http://cassandra.apache.org.

_Homebrew installation_

$brew install cassandra

_Apache distribution installation_

* Download a  Cassandra release from http://cassandra.apache.org/.
* Unpack the archive whereever you want.
* Create a symbolic link of the cassandra binary to your homedir's bin directory:
$mkdir -p ~/bin
$ln -s <path to your cassandra distribution>/bin/cassandra ~/bin/cassandra


Installation
------------

1.	Download the latest version: https://github.com/remysaissy/cassandra-macosx-prefspane/raw/master/download/Cassandra.prefPane.zip
2.	Unzip Cassandra.prefPane.zip
3.	Double click on Cassandra.prefPane. This will install it in your System Preferences

Note: To Mountain Lion users. This application is not on the app store and therefore it is not signed. Therefore, you must allow third party applications to be able to install this application. If you're wondering how to do it, here is an explanation: http://blog.remysaissy.com/2012/08/allowing-installation-of-non-mac-app.html

Contributing
------------

Feel free to let me know about your experience with this application.
And for those who want to contribute, don't be shy!

1. Fork it.
2. Create a branch (`git checkout -b my_cassandra_prefspane`)
3. Commit your changes (`git commit -am "Added Installer"`)
4. Push to the branch (`git push origin my_cassandra_prefspane`)
5. Create an [Issue][1] with a link to your branch
6. Enjoy a refreshing Diet Coke and wait

[1]: https://github.com/remysaissy/cassandra-macosx-prefspane/issues
