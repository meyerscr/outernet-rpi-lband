Introduction
============

While the image is downloading, let's take a brief tour of how the L-band
service works.

The files that are datacast by Outernet are encoded, modulated, and sent to
several Inmarsat satellites. These satellites transmit the radio waves in the
`L frequency band <https://en.wikipedia.org/wiki/L_band>`_. The waves are
received by a radio on your receiver and then passed on to the software
demodulator. The demodulator extracts demodulated data and passes it onto the
decoder, which extracts the file information from the data and reconstructs the
files on local storage.

The software components involved in this process are:

- the demodulator (sdr100)
- the decoder (ondd)
- file indexer (FSAL)
- web-based UI (Librarian)

Despite all this software coming from a single vendor, they don't come as a
single package for the reasons of flexibility and so that various components
can be replaced by others with same or similar functionality in future. Because
of this, much of this guide is going to be about ensuring that these pieces of
software work together.

.. note::
    Although these pieces of software are all part of the Outernet software
    eco-system, which is predominantly open-source, some of the executables are
    closed-source due to different business interests. Outernet is still
    committed to ultimately release all of its assets to the open-source
    community, so bear with us for now.

Virtually all of the software involved in this set-up is meant to be used as
long-running background processes (a.k.a. daemons). Some of the programs
already provide features that let them run as proper well-behaved daemons,
while others do not. Where appropriate, we will use screen as a quick-and-dirty
workaround (i.e., poor man's daemonization) solution.
