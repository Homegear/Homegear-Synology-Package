#!/bin/bash

# Run this script in a Debian wheezy debootstrap or docker environment for all three processor types used by Synology (armel, i386, amd64)

if test -z $1; then
	echo "Please provide a valid CPU architecture."	
	print_usage
	exit 1
fi

arch=$1

download() {
	wget http://homegear.eu/downloads/nightlies/$1
	ar -x $1
	rm $1
	tar -zxf data.tar.gz
	tar -zxf control.tar.gz
	rm data.tar.gz
	rm control.tar.gz
}

mkdir -p /synologyBuild
cd /synologyBuild
rm -Rf *

wget https://github.com/Homegear/Homegear-Synology-Package/archive/master.zip
unzip master.zip
rm master.zip
cd Homegear-Synology-Package-master/Template

download libhomegear-base_current_debian_wheezy_${arch}.deb
version=`cat control | grep Version: | cut -d " " -f 2`
arch=`cat control | grep Architecture: | cut -d " " -f 2`
download homegear_current_debian_wheezy_${arch}.deb
download homegear-homematicbidcos_current_debian_wheezy_${arch}.deb
download homegear-homematicwired_current_debian_wheezy_${arch}.deb
download homegear-insteon_current_debian_wheezy_${arch}.deb
download homegear-max_current_debian_wheezy_${arch}.deb
download homegear-philipshue_current_debian_wheezy_${arch}.deb
download homegear-sonos_current_debian_wheezy_${arch}.deb

mkdir -p Package/lib/homegear
echo "version=\"${version}\"" >> SPK/INFO

cp /usr/lib/pyshared/python2.7/lzo.so Package/lib/homegear
find /lib -name libbsd.so.0 -exec cp {} Package/lib/homegear \;
find /lib -name libgcrypt.so.11 -exec cp {} Package/lib/homegear \;
find /lib -name libglib-2.0.so.0 -exec cp {} Package/lib/homegear \;
find /lib -name libgpg-error.so.0 -exec cp {} Package/lib/homegear \;
find /lib -name liblzma.so.5 -exec cp {} Package/lib/homegear \;
find /lib -name libpcre.so.3 -exec cp {} Package/lib/homegear \;
find /lib -name libreadline.so.6 -exec cp {} Package/lib/homegear \;
find /lib -name libtinfo.so.5 -exec cp {} Package/lib/homegear \;
find /lib -name libdl.so.2 -exec cp {} Package/lib/homegear \;
find /lib -name libpthread.so.0 -exec cp {} Package/lib/homegear \;
find /lib -name libz.so.1 -exec cp {} Package/lib/homegear \;
find /lib -name librt.so.1 -exec cp {} Package/lib/homegear \;
find /lib -name libnsl.so.1 -exec cp {} Package/lib/homegear \;
find /lib -name libcrypt.so.1 -exec cp {} Package/lib/homegear \;
find /lib -name libm.so.6 -exec cp {} Package/lib/homegear \;
find /lib -name libc.so.6 -exec cp {} Package/lib/homegear \;
find /lib -name libgcc_s.so.1 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libcrypto.so.1.0.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libedit.so.2 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libenchant.so.1 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libexslt.so.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libgmodule-2.0.so.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libgmp.so.10 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libgnutls.so.26 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libltdl.so.7 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libmcrypt.so.4 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libp11-kit.so.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libqdbm.so.14 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libsqlite3.so.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libssl.so.1.0.0 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libtasn1.so.3 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libxml2.so.2 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libxslt.so.1 -exec cp {} Package/lib/homegear \;
find /usr/lib -iname libstdc++.so.6 -exec cp {} Package/lib/homegear \;

cp -R etc usr var Package

chmod 755 SPK/scripts/*

cd Package
tar -czf package.tgz *
mv package.tgz ../SPK
cd ../SPK
tar -cvf homegear-${version}-${arch}.spk *
cp homegear-*.spk ../../../
cd /synologyBuild
rm -Rf Homegear-Synology-Package-master