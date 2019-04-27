# Google drive with rclone

1. Install and configure rclone system-wide
2. Adapt and install the systemd unit. Mainly:
  - Edit the Drive mount name to match the one configured in step 1
  - Edit the HOME and USER placeholders
  - Optionally select a different mount point
3. Test the service works by starting and stopping it
       systemctl start google-drive
       systemctl stop google-drive
4. Install the NetworkManager dispatcher so the mount is stopped/started whe disconnecting/connecting from the network.

       sudo cp network-manager-dispatcher /etc/NetworkManager/dispatcher.d/02-google-drive
       chmod +x /etc/NetworkManager/dispatcher.d/02-google-drive

