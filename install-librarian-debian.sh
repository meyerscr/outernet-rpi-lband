#!/bin/bash

APT="apt-get -y --force-yes"
DEBIAN_FRONTEND=noninteractive
POOL_URL="http://ftp.debian.org/debian/pool/main"
PGHBA="/etc/postgresql/9.5/main/pg_hba.conf"
LIBRARIAN_VER="v4.0.post1"
PLATFORM="$(uname -n)"
ANY_SRC="${ANY_SRC:=common}"
SPOOLDIR="${SPOOLDIR:=/var/spool/ondd}"
DLDIR="${DLDIR:=/srv/downloads}"

export DEBIAN_FRONTEND

echo "Adding testing repositories"
cat /etc/apt/sources.list | sed 's/jessie/testing/' \
  > /etc/apt/sources.list.d/testing.list

echo "Install dependencies"
$APT install python python-pip postgresql libev-dev libpq-dev python-dev \
	build-essential

echo "Fix distlib"
wget "$POOL_URL/d/distlib/python-distlib_0.1.9-1_all.deb"
wget "$POOL_URL/d/distlib/python-distlib-whl_0.1.9-1_all.deb"
dpkg -i *.deb
rm *.deb

echo "Configuring PostgreSQL"
sed -ie 's|^(host .*) md5$|\1 trust|' "$PGHBA"
service postgresql restart

echo "Installing Librarian"
pip install \
  --extra-index-url "https://archive.outernet.is/sources/pypi/simple/" \
  "https://github.com/Outernet-Project/librarian/archive/$LIBRARIAN_VER.tar.gz"

echo "Configuring Librarian and FSAL"
mkdir -p /var/librarian
chmod 777 /var/librarian
install -Dm644 "${ANY_SRC}/librarian.ini" /etc/librarian.ini
install -Dm644 "${ANY_SRC}/fsal.ini" /etc/fsal.ini
sed_xp="s|%SITE_PACKAGES%|$SITE_PACKAGES|g;s|%PLATFORM%|$DISTRO|g"
sed -ie "$sed_xp" /etc/librarian.ini
sed -ie "$sed_xp" /etc/fsal.ini
python=$(which python2)
site_packages=$(${PYTHON} -c 'import site; print(site.getsitepackages()[0])')
