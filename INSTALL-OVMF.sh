#!/bin/bash
checkdeps=$(command -v rpmextract wget)
echo checking deps...
if [ "$checkdeps" = "/usr/bin/rpmextract \/usr/bin/wget" ]
then
	exit
else
	sudo xbps-install rpmextract wget
fi
mkdir edk2
cd edk2
packagelist=$(wget -qO- https://www.kraxel.org/repos/jenkins/edk2/ | sed -e 's/<[^>]*>//g' | grep noarch.rpm | sed 's/\.rpm.*/.rpm/')
echo downloading RPM files...
for i in $packagelist; do
	echo $i
	wget --progress=bar:force http://www.kraxel.org/repos/jenkins/edk2/$i
done
echo extracting...
for i in $packagelist; do
	rpmextract $i
done
echo installing/upgrading...
sudo rm -rf /usr/share/edk2.git
sudo rm -rf /usr/share/doc/edk2.git-ovmf-x64
sudo rm -rf /usr/share/doc/edk2.git-ovmf-ia32
sudo mv -f -v ./usr/share/edk2.git /usr/share/
sudo mv -f -v ./usr/share/doc/edk2.git-ovmf-x64 /usr/share/doc/
sudo mv -f -v ./usr/share/doc/edk2.git-ovmf-ia32 /usr/share/doc/
cd ..
rm -rf edk2
echo making backup of conf file...
sudo cp /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.old
echo
echo ------PLEASE MANUALLY REPLACE THE nvram SECTION OF /etc/libvirt/qemu.conf TO THE FOLLOWING------
line11='nvram = ['
line12='   "/usr/share/edk2.git/ovmf-x64/OVMF_CODE-pure-efi.fd:/usr/share/edk2.git/ovmf-x64/OVMF_VARS-pure-efi.fd",'
line13='   "/usr/share/edk2.git/ovmf-ia32/OVMF_CODE-pure-efi.fd:/usr/share/edk2.git/ovmf-ia32/OVMF_VARS-pure-efi.fd",'
line14='   "/usr/share/edk2.git/aarch64/QEMU_EFI.fd:/usr/share/edk2.git/aarch64/QEMU_VARS.fd",'
line15='   "/usr/share/edk2.git/arm/QEMU_EFI.fd:/usr/share/edk2.git/arm/QEMU_VARS.fd"'
line16=']'
echo $line11
echo $line12
echo $line13
echo $line14
echo $line15
echo $line16
echo
echo all done.
