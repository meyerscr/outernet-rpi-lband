Running the software stack
==========================

Although the individual commands can be run directly in the terminal, we will
use screen so the programs can be run in the background even after we log out
of the system.

screen basics
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
- decoder (ondd)
- web based interface (librarian)

Let's start screen as root. We will name this session 'outernet' so we can
refer to it in future. ::

    $ sudo screen -S outernet

Running the demodulator
~~~~~~~~~~~~~~~~~~~~~~~

In the first shell, let's start the demodulator. We first need to find out the
profile we should use. To do this run ``demod-profile`` without any arguments.
Once we know the profile name (in this example, we will use 'global'), we run
the following command::

    # demod-profile global

Running the decoder
~~~~~~~~~~~~~~~~~~~

Now we need to create another shell with Ctrl-A Ctrl-C. In the new shell, we
will run the decoder. Refer to the download and download cache locations we
decided on in the :doc:install section. ::

    # ondd -V -c /var/spool/ondd -o /srv/downloads -D /var/run/ondd.data


Starting the indexer
~~~~~~~~~~~~~~~~~~~~

After creating a new shell with Ctrl-A Ctrl-C, the indexer is started using the 
``fsal`` command::

    # fsal --conf /etc/fsal.ini

Starting the web UI
~~~~~~~~~~~~~~~~~~~

We create yet another shell with Ctrl-A Ctrl-C. In this shell, we will start
Librarian::

    # librarian --conf /etc/librarian.ini

Within less than a minute, the server will start responding on the port 80.

Detaching from the screen session
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After starting all the software, we may now detach from the screen session by
using the Ctrl-A Ctrl-D combination.

At some later time, if we wish to see what the programs are doing, we can
reattach to the session with ``screen -rDS outernet``.
