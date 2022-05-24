#!/bin/bash
#$1 is root partition
#$2 is swap partition
#$3 is the user name

BASE=base \
base-devel \
linux \
linux-firmware \
bash-completion
networkmanager \
network-manager-applet \
modemmanager \
usb_modeswitch \
exfatprogs \
e2fsprogs \
nilfs-utils \
f2fs-tools \
ntfs-3g \
nano \
grub \
doas \
xorg-server \
arandr \
udisks2 \
udiskie \
xdg-users-dirs \
p7zip \
unrar \
zip \
unzip \
v4l-utils \
libinput \
xorg-xinput \
polkit \
gvfs \
gvfs-mtp \
gvfs-gphoto2 \
gvfs-afc \
xarchiver \
tumbler \
poppler-glib \
ffmpegthumbnailer \
freetype2 \
libgsf \
gnome-epub-thumbnailer \

FONTS=ttf-liberation \
ttf-croscore \
ttf-carlito \
ttf-caladea \
ttf-roboto \
ttf-bitstream-vera \
ttf-dejavu \
ttf-droid \
ttf-ibm-plex \
ttf-anonymous-pro \
ttf-cascadia-code \
ttf-junicode \
ttf-joypixels \
ttf-linux-libertine \
ttf-hannom \
ttf-khmer \
ttf-arphic-uming \
ttf-indic-otf \
otf-latin-modern \
otf-latinmodern-math \
texlive-core \
texlive-fontsextra \
xorg-fonts-type1 \
xorg-fonts-alias-misc \
xorg-fonts-alias-cyrillic \
xorg-fonts-alias-75dpi \
xorg-fonts-alias-100dpi \
dina-font \
terminus-font \
tex-gyre-fonts \
gnu-free-fonts \
noto-fonts \
noto-fonts-cjk \
noto-fonts-emoji \
cantarell-fonts \
tamsyn-font \

HARDWARE=xf86-input-libinput \
xf86-input-evdev \
amd-ucode \
intel-ucode \
xorg-drivers \
mesa \
xf86-video-amdgpu \
xf86-video-ati \
xf86-video-amdgpu \
xf86-video-intel1 \
xf86-video-nouveauxf86-video-amdgpu \
xf86-video-ati \
xf86-video-amdgpu \
xf86-video-intel1 \
xf86-video-nouveau \
alsa-firmware \
sof-firmware \
alsa-ucm-conf \
gstreamer-vaapi \
gst-plugins-bad \
intel-media-driver \
libva-intel-driver \
libva-mesa-driver \
mesa-vdpau \
libva-vdpau-driver \
libvdpau-va-gl \

APPEREANCE=lightdm \
lightdm-gtk-greeter \
lightdm-gtk-greeter-settings \
lxappearance-gtk3 \
papirus-icon-theme \
hicolor-icon-theme \
adwaita-icon-theme \
gnome-icon-theme-extras \
gnome-themes-extra \
gtk-engine-murrine \
libnotify \
xfce4-notifyd \
menumaker \
archlinux-xdg-menu \

PACKAGES=$BASE $HARDWARE $FONTS $APPEREANCE

# set the keyboard
loadkeys la-latin1

# update the time
timedatectl set-ntp true &&

mkfs.ext4 $1 &&
mkswap $2 &&
mount $1 /mnt &&
swapon $2 &&

# get the latest fastest mirrors
reflector --latest 200 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt $PACKAGES &&

genfstab -U /mnt >> /mnt/etc/fstab &&
arch-chroot /mnt /bin/bash <<EOF
echo "permit :wheel" >> /etc/doas.conf 
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf
echo "complete -cf doas" >> /etc/bash.bashrc

xset fp rehash

systemctl enable NetworkManager
systemctl start NetworkManager
systemctl enable ModemManager
systemctl start ModemManager
systemctl restart NetworkManager

ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "es_PE.UTF-8 UTF-8" >> /etc/locale.gen
echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=la-latin1" > /etc/vconsole.conf
localectl --no-convert set-x11-keymap latam pc105 "" ""

echo "blacklist iTCO_wdt" > /etc/modprobe.d/nowatchdog 
echo "install iTCO_wdt /bin/true" > /etc/modprobe.d/blacklist.conf 

grub-install --target=i386-pc `lsblk -dpno pkname $1`
cd /etc/systemd/system
mkdir -p getty@tty1.service.d
cd getty@tty1.service.d
echo "[Service]" >> noclear.conf
echo "TTYVTDisallocate=no" >> noclear.conf
sed -i -e "/GRUB_CMDLINE_LINUX_DEFAULT=/s/^#*/#/" /etc/default/grub
sed -i -e "/GRUB_DISABLE_OS_PROBER=/s/^#//" /etc/default/grub
echo "loglevel=3 nowatchdog mitigations=off" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
cd

echo ":::::Enter root password:::::"
passwd
useradd -m -G wheel,users,adm,ftp,games,http,log,rfkill,sys,uucp -s /bin/bash $3 
echo ":::::Enter user password:::::"
passwd $3

exit
EOF

umount -R /mnt
