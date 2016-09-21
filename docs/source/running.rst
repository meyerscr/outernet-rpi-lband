Running the software stack
==========================

Although the individual commands can be run directly in the terminal, we will
use screen so the programs can be run in the background even after we log out
of the system.

Screen basics
-------------

Screen is a terminal multiplexer. Once started, you will be in a shell that
does not look much different than the normal shell. The special key combination
Ctrl-A can be used to give special screen-specific commands.

To create more shells (called 'windows'), press Ctrl-A Ctrl-C. To switch
between open shells, use Ctrl-A Ctrl-A (switches between the current and last
used shell), or Ctrl-A Ctrl-' to get a list of shells to switch to.

To exit screen without closing any of the open shells, press Ctrl-A Ctrl-D. To
reattach to the closed shells, run screen with ``screen -rD`` command.

Type ``man screen`` for complete usage documentation and/or use Ctrl-A Ctrl-?
to get information about screen shortcuts.

Running the programs
--------------------

Programs are run in this order:

- demodulator (demod)
- decoder (decoder)
- web based interface (librarian)

Let's start screen. We will name this session 'outernet' so we can refer to it
in future. ::

    $ screen -S outernet

If you haven't reconfigured udev during installation, you will need to run 
screen as root::

    $ sudo screen -S outernet

Running the demodulator
~~~~~~~~~~~~~~~~~~~~~~~

In the first shell, let's start the demodulator. We first need to find out the
profile we should use. To do this run ``demod-presets`` without any arguments.
Once we know the profile name (in this example, we will use 'euraf'), we run
the following command::

    $ demod-presets euraf

Running the decoder
~~~~~~~~~~~~~~~~~~~

Now we need to create another shell with Ctrl-A Ctrl-C. In the new shell, we
will run the decoder. ::

    $ decoder


Starting the indexer
~~~~~~~~~~~~~~~~~~~~

After creating a new shell with Ctrl-A Ctrl-C, the indexer is started using the 
``fsal`` command::

    $ fsal --conf /etc/fsal.ini

Starting the web UI
~~~~~~~~~~~~~~~~~~~

We create yet another shell with Ctrl-A Ctrl-C. In this shell, we will start
Librarian::

    $ librarian --conf /etc/librarian.ini

Within less than a minute, the server will start responding on the port 80.

Detaching from the screen session
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After starting all the software, we may now detach from the screen session by
using the Ctrl-A Ctrl-D combination. This session will continue to run in the 
background as long as the device has power and is not rebooted.

At some later time, if we wish to see what the programs are doing, we can
reattach to the session with ``screen -rDS outernet``.
