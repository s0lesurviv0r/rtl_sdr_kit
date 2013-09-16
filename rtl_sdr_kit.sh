#    rtl_sdr_kit - Installs and updates GNURadio, OsmoSDR, RTLSDR, and GQRX from source code hosted at respective Git repositories.
#    Copyright (C) 2013  Jacob Zelek <jacob@jacobzelek.com>
#
#     Updates:
#     2013-09-15 - GQRX installation added
#
#     2013-02-11 - Rewritten to detect if sudo is installed then display commands to install it.
#		apt-get command given --force-yes argument to force unauthenticated packages to install.
#		"apt-get update" line added to update package index before installing prereqs (Thanks to Wolfgang Schenk for bug report)
#
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash

preinstall()
{
	sudo apt-get update
	sudo apt-get -y --force-yes install libfontconfig1-dev libxrender-dev libpulse-dev \
	swig g++ automake autoconf libtool python-dev libfftw3-dev \
	libcppunit-dev libboost-all-dev libusb-1.0.0-dev fort77 \
	libsdl1.2-dev python-wxgtk2.8 git-core guile-1.8-dev \
	libqt4-dev python-numpy ccache python-opengl libgsl0-dev \
	python-cheetah python-lxml doxygen qt4-dev-tools \
	libqwt5-qt4-dev libqwtplot3d-qt4-dev pyqt4-dev-tools python-qwt5-qt4 \
	cmake git-core qtcreator
	
	return 0
}

git_gqrx()
{
	git clone https://github.com/csete/gqrx.git gqrx &> /dev/null
	return $?
}

pull_gqrx()
{
	cd gqrx/
	git pull &> /dev/null
	EXIT_CODE=$?
	cd ..

	return $EXIT_CODE
}

in_gqrx()
{
	cd gqrx/
	mkdir build
	cd build/

	qmake ../
	if [ $? -ne 0 ]
	then
		return $?
	fi	
	
	echo "Compiling..."

	make
	if [ $? -ne 0 ]
	then
		return $?
	fi

	echo "Installing..."

	sudo make install
	if [ $? -ne 0 ]
	then
		return $?
	fi

	sudo ldconfig
	if [ $? -ne 0 ]
	then
		return $?
	fi

	cd ../..
	return $?
}

git_gnuradio()
{
	git clone https://github.com/gnuradio/gnuradio.git gnuradio &> /dev/null
	return $?
}

pull_gnuradio()
{
	cd gnuradio/
	git pull &> /dev/null
	EXIT_CODE=$?
	cd ..

	return $EXIT_CODE
}

in_gnuradio()
{
	cd gnuradio/
	mkdir build
	cd build/

	cmake ../
	if [ $? -ne 0 ]
	then
		return $?
	fi	
	
	echo "Compiling..."

	make
	if [ $? -ne 0 ]
	then
		return $?
	fi

	echo "Installing..."

	sudo make install
	if [ $? -ne 0 ]
	then
		return $?
	fi

	sudo ldconfig
	if [ $? -ne 0 ]
	then
		return $?
	fi

	cd ../..
	return $?
}

git_osmosdr()
{
	git clone git://git.osmocom.org/gr-osmosdr gr-osmosdr &> /dev/null
	return $?
}

pull_osmosdr()
{
	cd gr-osmosdr/
	git pull &> /dev/null
	EXIT_CODE=$?
	cd ..
	return $EXIT_CODE
}

in_osmosdr()
{
	cd gr-osmosdr/
	mkdir build
	cd build/
	cmake ../
	echo "Compiling..."
	make
	echo "Installing..."
	sudo make install
	sudo ldconfig
	cd ../..
	return $?
}

git_rtlsdr()
{
	git clone git://git.osmocom.org/rtl-sdr.git rtl-sdr &> /dev/null
	return $?
}

pull_rtlsdr()
{
	cd rtl-sdr/
	git pull &> /dev/null
	EXIT_CODE=$?
	cd ..
	return $EXIT_CODE
}

in_rtlsdr()
{
	cd rtl-sdr/
	mkdir build
	cd build/

	cmake ../
	if [ $? -ne 0 ]
	then
		return $?
	fi

	echo "Compiling..."

	make
	if [ $? -ne 0 ]
	then
		return $?
	fi
	echo "Installing..."

	sudo make install
	if [ $? -ne 0 ]
	then
		return $?
	fi
	
	echo "Installing udev rules"
	sudo cp ../rtl-sdr.rules /etc/udev/rules.d/15-rtl-sdr.rules

	sudo ldconfig
	if [ $? -ne 0 ]
	then
		return $?
	fi

	cd ../..
	return $?
}

execute()
{
	actions=$1	
	msgs=$2

	for (( i=0; i<${#actions[@]}; i++ ))
	do
		echo ${msgs[i]} "[IN PROGRESS]"

		${actions[i]}

		if [ $? -eq 0 ]
		then
			echo ${msgs[i]} "[DONE]"
		else
			echo ${msgs[i]} "[FAIL]"
			exit 2
		fi
	done
}

install()
{
	actions=("preinstall" "git_gnuradio" "git_rtlsdr" "git_osmosdr" "git_gqrx" "in_gnuradio" "in_rtlsdr" "in_osmosdr" "in_gqrx")
	msgs=("Install prequesites" "Git checkout GNURadio" "Git checkout RTL-SDR" "Git checkout OsmoSDR" "Git checkout GQRX" "Install GNURadio" "Install RTL-SDR" "Install OsmoSDR" "Install GQRX")

	execute "${actions}" "${msgs}"
}

update()
{
	actions=("pull_gnuradio" "pull_rtlsdr" "pull_osmosdr" "pull_gqrx" "in_gnuradio" "in_rtlsdr" "in_osmosdr" "in_gqrx")
	msgs=("Git pull GNURadio" "Git pull RTL-SDR" "Git pull OsmoSDR" "Git pull GQRX" "Install GNURadio" "Install RTL-SDR" "Install OsmoSDR" "Install GQRX")

	execute "${actions}" "${msgs}"
}

fetch()
{
	actions=("pull_gnuradio" "pull_rtlsdr" "pull_osmosdr" "pull_gqrx")
	msgs=("Git pull GNURadio" "Git pull RTL-SDR" "Git pull OsmoSDR" "Git pull GQRX")

	execute "${actions}" "${msgs}"
}

check_sudo()
{
	sudo > /dev/null 2> /dev/null
	if [ $? -eq 127 ]
	then
		echo "This script requires sudo. Use the following commands to do this:"
		echo ""
		echo "$ su"
		echo "# apt-get install sudo"
		echo "# adduser <username> sudo"
		echo "# exit"	
		exit 1
	fi
}

case "$1" in
	install)
		check_sudo
		install
		;;
	update)
		check_sudo
		update
		;;
	fetch)
		fetch
		;;
	*)
		echo "rtl_sdr_kit - Installs and updates GNURadio, OsmoSDR, RTLSDR, and GQRX from source code hosted at respective Git repositories."
		echo ""
		echo "Usage: $0 [install|update|fetch]"
		exit 1
		;; 
esac
