Software installation
=====================

In this section, we will install all the necessary software and ensure the
system is prepared to run it. The next section will discuss the programs'
usage.

Preparing the device
--------------------

Connect your Raspberry Pi to a router either using WiFi (Raspberry Pi 3) or LAN
cable (all versions). Also plug in the SDR radio, and attach the LNA and
antenna to it. If you want to use a keyboard and a monitor, hook those up as
well.

Download locations
------------------

Before we begin, we need to decide on where to put the downloaded files. There
are two directories where files will be stored:

- temporary cache directory for unfinished downloads
- permanent directory for finished downloads

In this guide, we will use ``/var/spool/ondd`` for temporary download cache,
and ``/srv/downloads`` for finished downloads. Whether you go with these or
some other locations, it is recommended you write them down for future
reference.

Let's create the download locations::

    $ sudo mkdir -p /var/spool/ondd /srv/downloads

Switching to Raspbian testing
-----------------------------

Your Raspbian install is going to be 'upgraded' to the testing repository. If
you are not sure this is a good idea (or you know it is not), we recommend
creating an SD card specifically for running the Outernet software, rather than
modifying your existing cards. 

To upgrade to Raspbian testing, we will run the following commands::

    $ cat /etc/apt/sources.list | sed 's/jessie/testing/' | sudo tee /etc/apt/sources.list.d/testing.list
    $ sudo apt-get update
    $ sudo apt-get upgrade

It is a good idea to reboot once after the previous steps.

Installing dependencies
-----------------------

Apart from the software mentioned in the :doc:intro section, we also need a few
of the usual Raspbian packages that these programs depend on. ::

    $ sudo apt-get install postgresql libev-dev libpq-dev python-dev build-essential screen libusb-1.0

Due to a bug in the ``python-distlib``, this package needs to be downgraded. To
do this, run::

    $ wget http://ftp.debian.org/debian/pool/main/d/distlib/python-distlib_0.1.9-1_all.deb
    $ wget http://ftp.debian.org/debian/pool/main/d/distlib/python-distlib-whl_0.1.9-1_all.deb
    $ sudo dpkg -i *.deb

Configuring postgres
--------------------

Raspbian's PostgreSQL package, by default, enforces stricter access control.
For the quick set-up we are doing, we will need to loosen it up a little. Edit
the file named ``/etc/postgresql/9.5/main/pg_hba.conf`` and find the lines that
start with ``host`` and end in ``md5``. Change the ``md5`` portion to
``trust``.  This causes all connections coming from within the Raspberry Pi to
be treated as trusted connection. Once the configuration is modified, we need
to restart the database server::

    $ sudo service postgresql restart

.. warning::
    This PosgreSQL configuration is unsafe if you ware exposing Raspberry Pi to
    the Internet with its default SSH username and password.

Installing the Outernet software
--------------------------------

Now we are ready to install the Outernet software. All necessary software is
located in the Outernet's source repository at `archive.outernet.is/sources/ 
<https://archive.outernet.is/sources/>`_ (even though some of the software are
not source tarballs).

Installing ONDD
---------------

To install ONDD::

    $ wget https://archive.outernet.is/sources/ondd-rpi3-armhf-2.2.0.tar.gz
    $ tar xvf ondd-rpi3-armhf-2.2.0.tar.gz
    $ cd ondd-rpi3-armhf-2.2.0

Before installing, please review the license file found in the unpacked
directory and make sure you find it agreeable. To complete the install::

    $ sudo make install

ONDD license is found in the ``/usr/local/share/doc/ondd/LICENSE.txt``.

Installing StarSDR and L-band demodulator
-----------------------------------------

To install the StarSDR library and the demodulator program::

    $ wget https://archive.outernet.is/sources/starsdr-rpi3-armhf-2.0.tar.gz
    $ tar xvf starsdr-rpi3-armhf-2.0.tar.gz
    $ cd starsdr-rpi3-armhf-2.0

Before installing, please review the license file found in the unpacked
directory and make sure you find it agreeable. To complete the install::

    $ sudo make install

Installing Librarian user interface
-----------------------------------

The Librarian user interface is a Python application, and is therefore
installed using ``pip``::

    $ sudo pip install --extra-index-url https://archive.outernet.is/sources/pypi/simple/ https://github.com/Outernet-Project/librarian/archive/v4.0.post1.tar.gz

.. note::
    Some of the packages will require C extensions, so expect the installation
    to take a while.

Creating the Librarian configuration file
-----------------------------------------

Librarian must be configured before it can run with our set-up. To do this
create and edit a file /etc/librarian.ini (it can be anywhere as long as your
remember the location and adjust the example commands accordingly):

.. code-block:: 'ini'

    [config]

    defaults =
        /usr/local/lib/python2.7/dist-packages/librarian/config.ini

    [app]

    debug = no
    bind = 0.0.0.0
    port = 80
    default_route = filemanager:list
    default_route_args =
        path:

    [ondd]

    band = l
    demod_restart_command = echo 'noop'

    [lock]

    file = /var/run/librarian.lock

    [platform]

    name = rpi3
    version_file = /etc/version

    [logging]

    output = /var/log/librarian.log
    syslog = /var/log/messages
    size = 5M
    backups = 2
    fsal_log = /var/log/fsal.log

    [setup]

    file = /srv/librarian/librarian.json

    [mako]

    module_directory = /tmp/mako_cache

    [fsal]

    socket = /var/run/fsal.ctrl

    [menu]

    main = 
        files

    [cache]

    backend = in-memory
    timeout = 100

We also need to create the FSAL (filesystem indexer) configuration. Create and
edit a file called /etc/fsal.ini:

.. code-block:: 'ini'
        
    [config]

    defaults =
        /usr/lib/python2.7/site-packages/fsal/fsal-server.ini

    [fsal]

    # Adjust this as needed
    basepaths = 
      /srv/downloads 

    socket = /var/run/fsal.ctrl

    # Folders that are blacklisted
    +blacklist = 
      ^.platform(/.*)?$ 
      ^(.*/)?.thumbs(/.*)?$ 
      ^updates(/.*)?$ 
      ^legacy(/.*)?$ 
      ^FSCK.*.REC$

    [logging]

    output = /var/log/fsal.log
    size = 5M
    backups = 2

.. note::
    The example :download:`librarian.ini <examples/librarian.ini>` and 
    :download:`fsal.ini <examples/fsal.ini>` are provided for convenience.

Add the version file
--------------------

Although not strictly required, we will add a version file for completeness.
Note the version in the table at the start of this guide and echo that version
into the version file::

    $ echo 'VERSION' | sudo tee /etc/version
