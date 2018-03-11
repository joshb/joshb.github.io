---
layout: post
title: Making a Bootable Windows 10 USB Drive on macOS High Sierra
date: 2017-11-23
---
I recently put together a new gaming PC for the first time in several years. This was my first time installing Windows 10, and it turned out to be a bit of a challenge, as I opted to purchase a downloadable copy through Microsoft's website and transfer it to a USB drive on my Mac running macOS High Sierra. Microsoft provides a tool for creating a bootable Windows 10 installation drive from an existing Windows system, but not for macOS, and there is some conflicting information online about how to go about doing that.

My first instinct was to use `dd` to copy the ISO to the USB drive (as one typically does when installing a Linux distribution, for example), but it turns out that this does not satisfy the UEFI boot process. After some research and a lot of trial and error, I found that the USB drive must be formatted with a FAT32 partition and the MBR partitioning scheme, after which you can simply mount the Windows 10 ISO in macOS and copy the files to the drive.

 Formatting the USB drive can be done from the command-line fairly easily. First, run `diskutil list` and find the identifier of the USB drive (this will be something like `disk2` or `disk3`; make sure you find the right one, since you could erase the wrong drive and lose data if you don't use the correct identifier). Next, the following command can be used to format the drive (replace `disk#` with the actual identifier for your USB drive) and mount it as a volume named `WINDOWS10`:

```sh
diskutil eraseDisk MS-DOS "WINDOWS10" MBR disk#
```

Now you can mount the Windows 10 ISO by opening it through Finder and copy its contents to the USB drive. Oddly enough, copying the files through Finder did not work for me - I received an error about the files being too large, even though the partition on the drive was definitely big enough, and no individual file appeared to be too large for the FAT32 file system. Eventually I found that using `cp` from the command-line did work without any issues. When I opened the Windows 10 Fall Creators Update ISO, it mounted as a volume named `CCCOMA_X64FRE_EN-US_DV9`, so I used the following command to copy its contents to the USB drive:

```sh
cp -rp /Volumes/CCCOMA_X64FRE_EN-US_DV9/* /Volumes/WINDOWS10/
```

This command will take a while, and once it finishes, you can safely eject the drive through Finder and you should be able to boot from it to install Windows 10 on a PC.
