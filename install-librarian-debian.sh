#!/bin/bash

APT="apt-get -y --force-yes"
DEBIAN_FRONTEND=noninteractive
POOL_URL="http://ftp.debian.org/debian/pool/main"
PGHBA="/etc/postgresql/9.6/main/pg_hba.conf"
LIBRARIAN_VER="v4.0.post1"
PLATFORM="$(uname -n)"
ANY_SRC="${ANY_SRC:=common}"
SPOOLDIR="${SPOOLDIR:=/var/spool/ondd}"
DLDIR="${DLDIR:=/srv/downloads}"

export DEBIAN_FRONTEND

fail() {
  msg="$1"
  echo "$msg"
  exit 1
}

echo "Adding testing repositories"
cat /etc/apt/sources.list | sed 's/jessie/testing/' \
  > /etc/apt/sources.list.d/testing.list

echo "Install dependencies"
$APT update || fail "Could not update local package database"
$APT install python python-pip postgresql libev-dev libpq-dev python-dev \
	build-essential || fail "Could not install dependencies"

python=$(which python2)
site_packages=$(${python} -c 'import site; print(site.getsitepackages()[0])')

echo "Configuring PostgreSQL"
sed -ie 's|^\(host .*\) md5$|\1 trust|' "$PGHBA" \
  || fail "Could not configure PostgreSQL"
service postgresql restart || fail "Could not start PostgreSQL"

echo "Installing Librarian"
pip install \
  --extra-index-url "https://archive.outernet.is/sources/pypi/simple/" \
  "https://github.com/Outernet-Project/librarian/archive/$LIBRARIAN_VER.tar.gz" \
  || fail "Could not install Librarian"

echo "Configuring Librarian and FSAL"
mkdir -p /var/librarian
chmod 777 /var/librarian
install -Dm644 "${ANY_SRC}/librarian.ini" /etc/librarian.ini
install -Dm644 "${ANY_SRC}/fsal.ini" /etc/fsal.ini
sed_xp="s|%SITE_PACKAGES%|$site_packages|g;s|%PLATFORM%|$DISTRO|g"
sed -ie "$sed_xp" /etc/librarian.ini || fail "Could not configure Librarian"
sed -ie "$sed_xp" /etc/fsal.ini || fail "Could not configure FSAL"

echo "Finished installing the web interface"
