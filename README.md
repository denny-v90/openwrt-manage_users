# Openwrt Manage_users
Permit to manage the available areas for each user

This simple module has been realized for 18.06 OpenWrt version.

It reads nodes list file /etc/config/nodes and the user's not available nodes/subnodes list from /etc/config/users.
At user login the nodes/subnodes are delete from dispatcher main node, making them inaccessible to the user.

# Dependencies
If your OpenWrt version is 18.06.*, then you are alright.
Otherwise if you have 19.07.0, then you have to install **luci-compat**. I tested my module on 19.07.03 but doesn't work because LuCI has evolved a lot.

However you need to create your users on the linux system and upgrade */etc/config/rpcd* according to your needs.

# Virtual Machine
I have upload an openwrt 19.07 VM with this features:
  - OpenWrt 19.07.0
  - package installed (luci, luci-compat, curl, openssh-sftp-server, shadow-useradd)
  - network settings (VM nic Bridge mode, openwrt config lan DHCP)
  - 2 user (tech, user) -> passwords are same of username
  - load manage_users files

