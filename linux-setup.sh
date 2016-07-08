#! /bin/bash

# Avahi
apt-get install -y avahi-daemon avahi-discover libnss-mdns

# Dundee Makerspace shared file server
apt-get install -y cifs-utils
mkdir /mnt/dmsPublicFiles
echo "# Dundee Makerspace public samba share" > /etc/fstab
echo "//dms-server.local/public /mnt/dmsPublicFiles cifs guest,rw 0 0" >> /etc/fstab
mount -a

# Set apt proxy by avahi hostname
echo 'Acquire::http::proxy "http://dms-server.local:3142";' >> /etc/apt/apt.conf.d/00proxy
echo 'Acquire::https::proxy "DIRECT";' >> /etc/apt/apt.conf.d/00proxy

# curl
apt-get install -y curl

# Add PPAs {
  
  # Google Chrome
  curl --silent https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

  # node.js v0.12
  curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
  NODE_VERSION=node_0.12
  DISTRO="$(lsb_release -s -c)"
  echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" > /etc/apt/sources.list.d/nodesource.list
  echo "deb-src https://deb.nodesource.com/$NODE_VERSION $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list

  # Atom editor from unofficial PPA
  add-apt-repository ppa:webupd8team/atom

# }

# Update package lists
apt-get update

# Mostly borrowed from https://github.com/jfhbrook/makerspace-linux/blob/master/chroot-commands.sh
# Install packages {

  # Basic support for compiling stuff
  apt-get install -y build-essential
  
  # Source control tools
  apt-get install -y bzr git mercurial subversion
  
  # Web browser
  apt-get install -y google-chrome-stable

  # Missing scripting languages/environments
  apt-get install -y php5 nodejs ruby

  # Missing package management tools
  apt-get install -y php-pear python-pip
  # Composer funky install script because using normal package managers is too sensible for PHP developers...
  COMPOSER_EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  COMPOSER_ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
  if [ "$COMPOSER_EXPECTED_SIGNATURE" = "$COMPOSER_ACTUAL_SIGNATURE" ]
  then
    php composer-setup.php --quiet
    rm composer-setup.php
  else
    >&2 echo 'ERROR: Invalid composer installer signature'
    rm composer-setup.php
  fi
  mv composer.phar /usr/local/bin/composer

  # 2D graphics tools
  apt-get install -y gimp inkscape

  # CAD software
  apt-get install -y blender freecad openscad wings3d

  # STL analysis/repair/etc tools
  apt-get install -y assimp-utils admesh meshlab

  # RepRap toolchain
  # TODO: slic3r, printrun, tools on thingiverse
  # TODO: thingiverse cli? (npm view thingiverse)
  apt-get install -y skeinforge

  # Arduino and AVR toolchain
  apt-get install -y gcc-avr arduino arduino-mk avrdude avr-libc

  # Text/code editing
  apt-get install -y vim okteta atom

  # Networking client/diagnostic tools
  apt-get install -y atftp elinks iptables netcat6 nslookup lftp pure-ftpd tcpdump telnet-bsd whois wireshark

  # Networking server tools
  # TODO: How do these behave on a livecd??
  # TODO: samba xinetd mysql??
  # TODO: ecstatic? (npm view ecstatic)
  apt-get install -y apache2 libapache2-mod-perl2 libapache2-mod-php5 sshd puppet

  # Hardware tools
  # TODO: ntpasswd
  apt-get install -y ddrescue gparted 

  # Audio/Video
  apt-get install -y audacity avidemux openshot qtractor sox vlc

  # Office Stuff
  apt-get remove -y sylpheed pidgin xpad

# }

# Install hardware {
  
  # Epson Stylus SX215 printer
  # Using gdebi in non-interactive mode instead of dpkg because it will resolve dependencies from official packages
  gdebi -n /mnt/dmsPublicFiles/Shared/Epson\ Stylus\ SX210/Linux/epson-inkjet-printer-escpr_1.6.1-1lsb3.2_amd64.deb
  gdebi -n /mnt/dmsPublicFiles/Shared/Epson\ Stylus\ SX210/Linux/epson-printer-utility_1.0.0-1lsb3.2_amd64.deb
  gdebi -n /mnt/dmsPublicFiles/Shared/Epson\ Stylus\ SX210/Linux/iscan-bundle-1.0.0.x64.deb/data/iscan-data_1.36.0-1_all.deb
  gdebi -n /mnt/dmsPublicFiles/Shared/Epson\ Stylus\ SX210/Linux/iscan-bundle-1.0.0.x64.deb/core/iscan_2.30.1-1~usb0.1.ltdl7_amd64.deb
  gdebi -n /mnt/dmsPublicFiles/Shared/Epson\ Stylus\ SX210/Linux/iscan-bundle-1.0.0.x64.deb/plugins/iscan-network-nt_1.1.1-1_amd64.deb
  apt-get install -y sane sane-utils libsane-extras xsane
  # TODO: Install the printer itself instead of just the drivers
  
  # TODO: HP Photosmart 5510 over the network

# }

# Upgrade all out of date packages
apt-get upgrade -y

# Clean up old packages
apt-get autoremove -y

# Node packages {

  npm install -g bower gulp grunt-cli

# }

# Atom packages {

  apm install emmet

# }

# Desktop shortcuts {

  cp *.desktop ~/Desktop

}
