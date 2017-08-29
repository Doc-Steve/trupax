#!/bin/bash

set -e

if [[ ! ("$#" -eq 1) ]]; then
    echo 'need version'
    exit 1
fi

TRUPAXJAR=build/trupax.jar
if [ ! -f $TRUPAXJAR ]
then
    echo "$TRUPAXJAR is missing"
    exit 2
fi

echo "preparing for Linux ..."
BUILD=TruPax$1
BUILDIR=tmp/$BUILD
SWTDIR=../swt
JREDIR=../jre-reduce
JRE_OUT=$BUILDIR/jre

. $JREDIR/version.inc
. $SWTDIR/version.inc

rm -f build/trupax$1_linux.zip
rm -f build/trupax$1_windows.zip
rm -rf $BUILDIR
mkdir -p $BUILDIR

cp $TRUPAXJAR               $BUILDIR/
cp etc/trupax.desktop       $BUILDIR/
cp etc/trupaxcmdrc_example  $BUILDIR/
cp etc/scripts/trupax       $BUILDIR/
cp etc/scripts/trupaxgui    $BUILDIR/
cp etc/scripts/install.sh   $BUILDIR/
cp etc/scripts/uninstall.sh $BUILDIR/
cp etc/images/trupax.png    $BUILDIR/ 

tr -d "\r" < LICENSE.txt      | cat > $BUILDIR/LICENSE
tr -d "\r" < etc/README.txt   | cat > $BUILDIR/README
tr -d "\r" < etc/LIESMICH.txt | cat > $BUILDIR/LIESMICH

cp lib/fat32-lib-0.6.5.jar $BUILDIR/

chmod 755 $BUILDIR/trupax
chmod 755 $BUILDIR/trupaxgui
chmod 755 $BUILDIR/install.sh
chmod 755 $BUILDIR/uninstall.sh

cp $SWTDIR/$SWT_VERSION/gtk-linux-x86_64/swt.jar $BUILDIR/

echo "reducing JRE for Linux ..."
rm -rf $JRE_OUT
tar xzf $JREDIR/versions/$JRE_VERSION/$JRE_UPDATE/jre-$JRE_VERSION$JRE_UPDATE-linux-x64.tar.gz -C $BUILDIR/
mv $BUILDIR/jre* $JRE_OUT
$JREDIR/jre-reduce.sh linux-x64 "$JRE_OUT"

echo "creating ZIP for Linux ..."
cd tmp
zip -9 -q -r -X ../build/trupax$1_linux.zip $BUILD
cd ..

echo "preparing for Windows ..."
rm -f $BUILDIR/LICENSE
rm -f $BUILDIR/README
rm -f $BUILDIR/LIESMICH
rm -f $BUILDIR/trupax.desktop
rm -f $BUILDIR/trupax.png
rm -f $BUILDIR/trupaxgui
rm -f $BUILDIR/trupax
rm -f $BUILDIR/*.sh
rm -f $BUILDIR/trupaxcmdrc_example

cp LICENSE.txt                      $BUILDIR/
cp etc/README.txt                   $BUILDIR/
cp etc/LIESMICH.txt                 $BUILDIR/
cp etc/scripts/trupax*.cmd          $BUILDIR/
cp etc/scripts/install.vbs          $BUILDIR/
cp etc/trupaxcmd_example.properties $BUILDIR/
cp etc/images/trupax.ico            $BUILDIR/ 

cp $SWTDIR/$SWT_VERSION/win32-win32-x86_64/swt.jar $BUILDIR/

echo "reducing JRE for Windows ..."
rm -rf $JRE_OUT
tar xzf $JREDIR/versions/$JRE_VERSION/$JRE_UPDATE/jre-$JRE_VERSION$JRE_UPDATE-windows-x64.tar.gz -C $BUILDIR/
mv $BUILDIR/jre* $JRE_OUT
$JREDIR/jre-reduce.sh windows-x64 $JRE_OUT

echo "creating ZIP for Windows ..."
cd tmp
zip -9 -q -r -X ../build/trupax$1_windows.zip $BUILD
cd ..

rm -rf tmp

ls -lah ./build/trupax$1_linux.zip
ls -lah ./build/trupax$1_windows.zip
