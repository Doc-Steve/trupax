#!/bin/bash
INSTDIR=/opt/trupax
echo installing TruPax to $INSTDIR ... 
./uninstall.sh "$INSTDIR"
sudo mkdir -p /opt/trupax
sudo cp -r --preserve=all * $INSTDIR
sudo chmod 755 $INSTDIR/trupax
sudo chmod 755 $INSTDIR/trupaxgui
sudo chmod 755 $INSTDIR/*install.sh
sudo ln -s $INSTDIR/trupax    /usr/bin/
sudo ln -s $INSTDIR/trupaxgui /usr/bin/
sudo cp trupax.desktop /usr/share/applications/
echo done.
