#!/bin/bash

get_secret()
{
    local secret_name=$1
    local path="/run/secrets/$secret_name"
    if [ -f "$path" ]; then
        cat "$path"
    else
        echo "Error: Secret '$secret_name' not found at '$path'" >&2
        exit 1
    fi 
}

mkdir -p /var/run/vsftpd/empty

cat << EOF > /etc/vsftpd.conf
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES

chroot_local_user=YES
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty

pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40005

background=NO
EOF

FTP_PASS=$(get_secret "ftp_password")

if ! id "$FTP_USER" >/dev/null 2>&1; then
    echo "Creating FTP user $FTP_USER..."
    useradd -d "/home/$FTP_USER" -M -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
else
    echo "$FTP_USER already exists."
fi

chown $FTP_USER:www-data -R /home/$FTP_USER

echo "FTP user '$FTP_USER' is ready !"

vsftpd /etc/vsftpd.conf || echo "VSFTPD crashed with err $?"