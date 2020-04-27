import os

if os.getuid() != 0:
    raise EnvironmentError("This script needs root privilages")

import subprocess as sp, pwd

USER = "miha"
SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))

print("Starting the OC settup...")

# install packages
packages = [ "pacman", "-Sy" ]
packages.append("networkmanager")
packages.append("xorg")
packages.append("awesome")
packages.append("noto-fonts")
packages.append("base-devel")
packages.append("wget")
packages.append("unzip")
packages.append("git")
packages.append("ufw")
packages.append("zsh")
packages.append("zsh-theme-powerlevel9k")
packages.append("zsh-syntax-highlighting")
packages.append("zsh-history-substring-search")
packages.append("zsh-completions zsh-autosuggestions")
packages.append("firefox")
packages.append("stow")
packages.append("rofi")
packages.append("alacritty")
packages.append("arandr")

print("Installing defined packages...")
sp.run(packages)

# enable network manager
print("Enabling NewtworkManager...")
sp.run(["systemctl", "enable", "NetworkManager"])
sp.run(["systemctl", "start", "NetworkManager"])

# enable firewall
print("Enabling firewall...")
sp.run(["ufw", "enable"])
print("firewall status:")
sp.run(["ufw", "status", "verbose"])

# install login manager
print("Installing login manager...")
lm_url = "https://github.com/cylgom/ly/archive/v0.5.0.zip"

sp.run(["sudo", "-u", USER, "wget", lm_url, "-O", "/tmp/ly.zip"])
sp.run(["sudo", "-u", USER, "unzip", "-o", "/tmp/ly.zip", "-d", "/tmp/"])
os.chdir("/tmp/ly-0.5.0")

sp.run(["sudo", "-u", USER, "make", "github"])
sp.run(["sudo", "-u", USER, "make"])
sp.run(["make", "install"])
sp.run(["systemctl", "enable", "ly.service"])
sp.run(["systemctl", "disable", "getty@tty2.service"])

# xorg config files
print("Copying X11 config files...")
monitor_config_path = os.path.join(os.path.join(SCRIPT_PATH, "X11"), "10-monitor.conf")
mouse_config_path = os.path.join(os.path.join(SCRIPT_PATH, "X11"), "50-mouse.conf")

monitors = sp.getoutput("xrandr")
if "Virtual-1 connected" in monitors:
    print("Skipping copyieng X11 config files")
else:
    sp.run(["cp", monitor_config_path, "/etc/X11/xorg.conf.d/"])
    sp.run(["cp", mouse_config_path, "/etc/X11/xorg.conf.d/"])

# TODO: KVM files

# create config directories
homedir = "/home/" + USER
configdir = home + "/.config"
localdir = home + "/local/share"

sp.run(["sudo", "-u", USER, "mkdir", "-p", configdir])
sp.run(["sudo", "-u", USER, "mkdir", "-p", localdir])

# create common folders
sp.run(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Documents"])
sp.run(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Downloads"])
sp.run(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Music"])
sp.run(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Pictures"])
sp.run(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Projects"])

# stow dotfiles
os.chdir("/home/" + USER + "/dotfiles")
sp.run(["sudo", "-u", USER, "stow", "alacritty", "compton", "fonts", "zsh", "rofi"])

print("done! :)")