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

echo "preparing ..."
BUILD=TruPax$1
DPLDIR=deploy
APPDIR=$DPLDIR/__temp__.app
FINDIR=$DPLDIR/TruPax.app
CONTDIR=$APPDIR/Contents
SWTDIR=../swt
JREDIR=../jre-reduce
DMGFILE=build/trupax$1.dmg

. $JREDIR/version.inc
. $SWTDIR/version.inc

rm -f $DMGFILE
rm -rf $CONTDIR

mkdir -p $CONTDIR/MacOS
mkdir    $CONTDIR/Resources

cp $TRUPAXJAR                $CONTDIR/MacOS/
cp etc/scripts/trupaxgui_osx $CONTDIR/MacOS/trupaxgui
cp etc/scripts/trupax_osx    $CONTDIR/MacOS/trupax
cp etc/Info.plist            $CONTDIR/
cp etc/images/trupax.icns    $CONTDIR/Resources/ 

tr -d "\r" < LICENSE.txt | cat > $CONTDIR/MacOS/LICENSE

cp lib/fat32-lib-0.6.5.jar   $CONTDIR/MacOS/

chmod 755 $CONTDIR/MacOS/trupax
chmod 755 $CONTDIR/MacOS/trupaxgui

cp -a $SWTDIR/$SWT_VERSION/cocoa-macosx-x86_64/swt.jar $CONTDIR/MacOS/

echo "reducing JRE ..."
tar xzf $JREDIR/versions/$JRE_VERSION/$JRE_UPDATE/jre-$JRE_VERSION$JRE_UPDATE-macosx-x64.tar.gz -C $CONTDIR/MacOS/
mv $CONTDIR/MacOS/jre* $CONTDIR/MacOS/jre
$JREDIR/jre-reduce.sh macosx-x64 $CONTDIR/MacOS/jre

mv $APPDIR "$FINDIR"
ln -s /Applications $DPLDIR/Applications

echo "creating DMG ..."
hdiutil create -volname "TruPax" -srcfolder $DPLDIR $DMGFILE
hdiutil internet-enable -yes $DMGFILE

rm -rf $DPLDIR

ls -lah $DMGFILE
