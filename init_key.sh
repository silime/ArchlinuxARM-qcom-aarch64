echo "Init Key"

pacman-key --init && pacman-key --populate
pacman-key --recv-keys F60FD4C6D426DAB6 && pacman-key --lsign F60FD4C6D426DAB6
echo -e '[qcom]\nServer = https://github.com/silime/ArchLinux-Packages/releases/latest/download/' >> /etc/pacman.conf

echo "Init Key completed"