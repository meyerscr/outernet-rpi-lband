Software installation
=====================

In this section, we will install all the necessary software and ensure the
system is prepared to run it. The next section will discuss the programs'
usage.

Preparing the device
--------------------

Connect your Raspberry Pi to a router either using WiFi (Raspberry Pi 3) or LAN
cable (all versions). Also plug in the SDR (software defined radio; rtlsdr dongle), and attach the LNA and
antenna. If you want to use a keyboard and a monitor, hook those up as
well.

Downloading the installer kit
-----------------------------

The installer and its files are now distributed as part of the `Outernet L-band
Service on Raspberry Pi respository on GitHub
<https://github.com/Outernet-Project/outernet-rpi-lband>`_. Download the
`latest stable version
<https://github.com/Outernet-Project/outernet-rpi-lband/archive/master.tar.gz>`
and extract it::

    $ tar xvf master.tar.gz

Running the installer
---------------------

Enter the unpacked directory and run the installer::

    $ cd outernet-rpi-lband-master
    $ sudo ./installer.sh

The installer will ask you a few things.

Configure udev
~~~~~~~~~~~~~~

The radio devices are accessible only to root user by default. If you wish to 
run the Outernet software as a non-root user (recommended), you should answer
``y`` to this question. Udev will be reconfigured so that the radio device is
accessible to non-root users.

.. note::
    If you choose to have the installer reconfigure udev, you will also need to 
    reconnect the radio for the changes to take effect.

Choose cache and storage paths
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cache path is where the decoder stores partial downloads. The storage directory
is where completed downloads will be written. If you wish to customize these
paths, then enter the correct paths. Otherwise, press Enter to accept the
defaults. 

You can also have the installer create these paths for you. When you choose
this option, the directories are created, and also set to 777 permissions. You 
can either answer with ``n`` to this question, and create the paths yourself
with appropriate permissions, or answer ``y`` to have the installer take care 
of it.

Install the web-based interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The installer can install and configure the web-based interface called 
`Librarian <https://librarian.outernet.is/>`_. This is not necessary to receive 
files, and you can always set up your own methods of accessing the files (e.g.,
FTP, HTTP server, etc). If you wish to try Librarian out, answer ``y`` to this 
question.

Uninstalling the software
-------------------------

To uninstall the software, run the installer and pass ``uninstall`` argument::

    $ cd outernet-rpi-lband-master
    $ sudo ./installer.sh uninstall

.. note::
    Uninstalling does not remove downloaded files or settings.
