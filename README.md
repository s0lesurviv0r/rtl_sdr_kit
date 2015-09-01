#rtl_sdr_kit

Installs and updates GNURadio, OsmoSDR, RTLSDR, and GQRX from source code hosted at respective Git repositories.

## Introduction

The RTL2832 is an inexpensive chipset used in USB DVB (Digital Video Broadcast) dongles. It can be used to collect raw I/Q samples and therefore be used for SDR (Software Defined Radio).

This shell script installs a suite of applications intended for beginners or those who simply want to explore the RTL2832's potential. This suite contains the following applications:

- GNURadio - "a free & open-source software development toolkit that provides signal processing blocks to implement software radios"
- OsmoSDR - "a 100% Free Software based small form-factor inexpensive SDR (Software Defined Radio) project"
- RTLSDR - Includes utilities specific to the RTL2832 on a hardware level
- GQRX - "Software defined radio receiver powered by GNU Radio and Qt"

## Install

<pre>
$ git clone https://github.com/jacobzelek/rtl_sdr_kit.git rtl_sdr_kit
$ cd rtl_sdr_kit
$ chmod +x rtl_sdr_kit.sh
$ ./rtl_sdr_kit.sh install
</pre>

## Update

<pre>
$ ./rtl_sdr_kit.sh update
</pre>

## Usage

The following applications can be executed from a shell (terminal)

### SDR Prototyping
`gnuradio-companion` - Design RF systems using RF "blocks" in a GUI environment

### RTL2832

`rtl_test` - Test functionality of RTL2832 dongle

`rtl_fm`

`rtl_tcp`

`rtl_sdr`

Please refer to http://sdr.osmocom.org/trac/wiki/rtl-sdr for details

### General
`gqrx` - GUI application for general purpose receiving
