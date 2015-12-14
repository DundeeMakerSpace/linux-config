#! /bin/bash

# Dundee Makerspace shared file server
mkdir /mnt/dmSharedStorage
echo "# Dundee Makerspace SMB share" >> /etc/fstab
echo "//192.168.0.2/storage /mnt/dmSharedStorage cifs rw,username=guest 0 0" >> /etc/fstab
mount /mnt/dmSharedStorage

# Add PPAs { 
  
  #
  # chrome
  # 
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.chrome.list
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

  # 
  # node v0.12
  # 
  wget -q -O - https://deb.nodesource.com/setup_0.12 | bash -

  # 
  # Atom editor
  # 
  add-apt-repository ppa:webupd8team/atom

# }

# Update package lists
apt-get update

# Mostly borrowed from https://github.com/jfhbrook/makerspace-linux/blob/master/chroot-commands.sh
# Install packages {

  #
  # Basic support for compiling stuff
  #
  apt-get install -y build-essential curl

  #
  # Missing scripting languages/environments
  #
  apt-get install -y php5 nodejs

  #
  # Missing package management tools
  #
  apt-get install -y php-pear pip rubygems
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer

  #
  # Source control tools
  #
  apt-get install -y bzr git mercurial svn

  #
  # 2d graphics tools
  #
  apt-get install -y gimp inkscape

  #
  # CAD software
  #
  apt-get install -y blender freecad openscad wings3d

  #
  # STL analysis/repair/etc tools
  #
  apt-get install -y assimp-utils admesh meshlab

  #
  # RepRap toolchain
  #
  # TODO: slic3r, printrun, tools on thingiverse
  # TODO: thingiverse cli? (npm view thingiverse)
  apt-get install -y skeinforge

  #
  # Arduino and AVR toolchain
  #
  apt-get install -y gcc-avr arduino arduino-mk avrdude avr-libc

  #
  # Text/code editing
  #
  apt-get install -y vim okteta atom

  #
  # Networking client/diagnostic tools
  #
  apt-get install -y atftp elinks iptables netcat6 nslookup pure-ftpd tcpdump telnet-bsd whois wireshark

  #
  # Networking server tools
  #
  # TODO: How do these behave on a livecd??
  # TODO: samba xinetd mysql??
  # TODO: ecstatic? (npm view ecstatic)
  apt-get install -y apache2 libapache2-mod-perl2 libapache2-mod-php5 sshd puppet

  #
  # Hardware tools
  # TODO: ntpasswd
  apt-get install -y ddrescue gparted 

  #
  # Audio/Video
  #
  apt-get install -y audacity avidemux openshot qtractor sox vlc

  #
  # Office Stuff
  #
  apt-get remove -y sylpheed pidgin xpad
  
  #
  # Interwebs
  #
  apt-get install -y google-chrome-stable

# }

# Upgrade all out of date packages
apt-get upgrade

# Node packages {

  npm install -g bower gulp grunt-cli

# }

# Atom packages {

  apm install emmet

# }

# Desktop shortcuts {

  cp *.desktop ~/Desktop

}
