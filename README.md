# 简介
- 本项目用于每天自动生成 **高通平台** 的 **ArchLinuxARM** **aarch64** 系统镜像
- 生成的镜像包含高通平台官方的闭源固件

 ## 下载地址

- **ArchLinuxARM-qcom-lenovo-q706f-latest.img.zip**：
  - https://github.com/silime/ArchlinuxARM-qcom-aarch64/releases/latest/download/ArchLinuxARM-qcom-lenovo-q706f-latest.img.zip
- **ArchLinuxARM-qcom-lenovo-q706f-latest.img.zip.sha256sum**：
  - https://github.com/silime/ArchlinuxARM-qcom-aarch64/releases/latest/download/ArchLinuxARM-qcom-lenovo-q706f-latest.img.zip.sha256sum
- **ArchLinuxARM-qcom-lenovo-q706f-latest-rootfs.tar.gz**：
  - https://github.com/silime/ArchlinuxARM-qcom-aarch64/releases/latest/download/ArchLinuxARM-qcom-lenovo-q706f-latest-rootfs.tar.gz
- **ArchLinuxARM-qcom-lenovo-q706f-latest-rootfs.tar.gz.sha256sum**：
  - https://github.com/silime/ArchlinuxARM-qcom-aarch64/releases/latest/download/ArchLinuxARM-qcom-lenovo-q706f-latest-rootfs.tar.gz.sha256sum
- **lenovo-q706f-boot.img**
  - https://github.com/silime/ArchlinuxARM-qcom-aarch64/releases/latest/download/lenovo-q706f-boot.img
- **lenovo-q706f-boot.img.sha256sum**
  - https://github.com/silime/ArchlinuxARM-qcom-aarch64/releases/latest/download/lenovo-q706f-boot.img.sha256sum

 ## 安装了以下软件包及其依赖

  ```
  archlinuxarm-keyring base dhcpcd dialog linux-sm8250 linux-firmware-lenovo-sm8250 linux-firmware-lenovo-sm8250-qcom linux-firmware-lenovo-sm8250-sensors linux-firmware-lenovo-sm8250-whence hexagonrpcd device-lenovo-q706f qbootctl iio-sensor-proxy nano net-tools netctl openssh networkmanager pulseaudio vi which wireless-regdb wireless_tools wpa_supplicant persistent-mac
  ```
  

 ## 启用了以下服务

  ```
  sshd systemd-networkd systemd-resolved systemd-timesyncd
  ```

  ### IMG文件的额外订制
  
  添加并启用了 **resize2fs_once.service** resize SD card
  
  ```
  [Unit]
  Description=Resize the root filesystem to fill partition

  [Service]
  Type=oneshot
  ExecStart=/usr/local/bin/growpart /dev/mmcblk0 2 ; /usr/sbin/resize2fs /dev/mmcblk0p2
  ExecStartPost=/usr/bin/systemctl disable resize2fs_once.service ; /usr/bin/rm -rf /etc/systemd/system/resize2fs_once.service /usr/local/bin/growpart

  [Install]
  WantedBy=multi-user.target
  ```
  
  该文件会将 **root** 分区扩展至整张sd卡并在完成后将自身删除
  
  添加了来自 **cloud-guest-utils** 的 **growpart** ，该文件在首次开机时被 **resize2fs_once.service** 使用后删除
  
  ## 安装教程
  
  ### 安装到外在存储
  
  使用 *balenaEtcher* 将 xxx-latest.img.zip 写入SD card 或 U 盘
  ```
  fastboot erase dtbo_x # 清除dtbo分区 dtbo_a or dtbo_b
  fastboot flash boot_x xxx-boot.img # 刷入boot分区 boot_a or boot_b
  fastboot set_active x # 激活刷入的分区
  ```
  插入sdcard 或 U盘，重启
  
  ### 安装到UFS
  下载 xxx-rootfs.tar.gz 到设备
  
  - 你可以使用 `parted` 对UFS进行分区，这里不进行分区，安装到userdata分区
  
  下载 *xxx-rootfs-boot.img* 镜像，UFS分区后需要使用[mkbootimg](https://android.googlesource.com/platform/system/tools/mkbootimg)修改cmdline
   
  重启到TWRP，adb shell 执行下面命令
  
  ```
  umount /sdcard && umount /data # 卸载分区
  mke2fs -t ext4 /dev/block/by-name/userdata # 格式化分区为ext4
  mount /dev/block/by-name/userdata /mnt # 挂载分区
  tar -zxvf xxx-rootfs.tar.gz -C /mnt # 释放根文件系统
  ```
  重启到fastboot `adb reboot bootloader`

  ```
  fastboot erase dtbo_x # 清除dtbo分区 dtbo_a or dtbo_b
  fastboot flash boot_x xxx-rootfs-boot.img # 刷入boot分区 boot_a or boot_b
  fastboot set_active x # 激活刷入的分区
  ```
 
  ## 使用方式

  **root** 的密码是 ```root```
  
  **alarm** 的密码是 ```alarm```
  
  镜像不提供桌面环境，你需要安装你想要的桌面环境

  ## Xiaoxin Pad Pro 12.6 Device status

| USB Networking   | Works   |
| :--------------- | ------- |
| Flashing         | Works   |
| Touchscreen      | Works   |
| Display          | Works   |
| WiFi             | Works   |
| FDE              | Works   |
| Mainline         | Works   |
| Battery          | Works   |
| 3D Acceleration  | Works   |
| Audio            | Partial |
| Bluetooth        | Works   |
| Camera           | Broken  |
| Internal storage | Works   |
| SD Card          | Works   |
| Charging         | Partial |
| DisplayPort      | Works   |
| Type-C           | Works   |
| Accelerometer    | Works   |
| :------------    | -----   |
| Magnetometer     | Works   |
| Ambient Light    | Works   |
| Proximity        | Works   |
