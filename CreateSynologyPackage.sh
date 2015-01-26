#!/bin/bash

# Run this script in a Debian Wheezy debootstrap environment for all three processor types used by Synology (armhf, i386, amd64)

if test -z $1
then
  echo "Please specify a Debian package to download."
  exit 0;
fi

mkdir -p /synologyBuild
cd /synologyBuild
rm -Rf *

wget https://github.com/Homegear/Homegear-Synology-Package/archive/master.zip
unzip master.zip
rm master.zip
cd Homegear-Synology-Package-master/Template

wget http://homegear.eu/packages/Debian/wheezy/$1
ar -x $1
rm $1
tar -zxf data.tar.gz
tar -zxf control.tar.gz
version=`cat control | grep Version: | cut -d " " -f 2`
arch=`cat control | grep Architecture: | cut -d " " -f 2`

mkdir -p Package/lib/homegear
echo "version=\"${version}\"" >> SPK/INFO

cp /usr/lib/pyshared/python2.7/lzo.so Package/lib/homegear
find /lib -name libgcrypt.so.11 -exec cp {} Package/lib/homegear \;
find /lib -name libgpg-error.so.0 -exec cp {} Package/lib/homegear \;
find /lib -name libreadline.so.6 -exec cp {} Package/lib/homegear \;
find /lib -name libtinfo.so.5 -exec cp {} Package/lib/homegear \;
find /lib -name libz.so.1 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libgnutls.so.26 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libp11-kit.so.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libsqlite3.so.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libstdc++.so.6 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libtasn1.so.3 -exec cp {} Package/lib/homegear \;

cp -R etc usr var Package

wget ftp://xmlsoft.org/libxml2/libxml2-git-snapshot.tar.gz
tar -zxf libxml2-git-snapshot.tar.gz
cd libxml2*
./configure
sed -i "s/^LDFLAGS =/LDFLAGS = -Wl,-rpath=\/lib\/homegear /" Makefile
make
cp .libs/xmllint ../Package/lib/homegear
cp .libs/libxml2.so.2 ../Package/lib/homegear
cd ..

wget http://ftp.gnu.org/gnu/patch/patch-2.7.tar.gz
tar -zxf patch-2.7.tar.gz
cd patch-2.7
./configure
sed -i "s/^LDFLAGS =/LDFLAGS = -Wl,-rpath=\/lib\/homegear /" Makefile
make
cp src/patch ../Package/lib/homegear
cd ..

cd Package
tar -czf package.tgz *
mv package.tgz ../SPK
cd ../SPK
tar -cvf homegear-${version}-${arch}.spk *
cp homegear-*.spk ../../../
cd /synologyBuild
rm -Rf Homegear-Synology-Package-master