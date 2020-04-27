import os

if os.getuid() != 0:
    raise EnvironmentError("This script needs root privilages")

import subprocess as sp, pwd

USER = "miha"
SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))

def execute(command):
    result = sp.run(command)
    result.check_returncode()

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
packages.append("zsh-completions")
packages.append("zsh-autosuggestions")
packages.append("firefox")
packages.append("stow")
packages.append("rofi")
packages.append("alacritty")
packages.append("arandr")

print("Installing defined packages...")
execute(packages)

# enable network manager
print("Enabling NewtworkManager...")
execute(["systemctl", "enable", "NetworkManager"])

# enable firewall (doesn't work in chroot)
#print("Enabling firewall...")
#execute(["ufw", "enable"])
#print("firewall status:")
#execute(["ufw", "status", "verbose"])

# install login manager
print("Installing login manager...")
lm_url = "https://github.com/cylgom/ly/releases/download/v0.5.0/ly_0.5.0.zip"

execute(["sudo", "-u", USER, "wget", lm_url, "-O", "/tmp/ly.zip"])
execute(["sudo", "-u", USER, "unzip", "-o", "/tmp/ly.zip", "-d", "/tmp/"])
os.chdir("/tmp/ly_0.5.0")
execute(["sh", "install.sh"])

execute(["systemctl", "enable", "ly.service"])
execute(["systemctl", "disable", "getty@tty2.service"])

# xorg config files
print("Copying X11 config files...")
monitor_config_path = os.path.join(os.path.join(SCRIPT_PATH, "configs"), "10-monitor.conf")
mouse_config_path = os.path.join(os.path.join(SCRIPT_PATH, "configs"), "50-mouse.conf")

execute(["cp", monitor_config_path, "/etc/X11/xorg.conf.d/"])
execute(["cp", mouse_config_path, "/etc/X11/xorg.conf.d/"])

# TODO: KVM files

# create config directories
homedir = "/home/" + USER
configdir = homedir + "/.config"
localdir = homedir + "/local/share"

execute(["sudo", "-u", USER, "mkdir", "-p", configdir])
execute(["sudo", "-u", USER, "mkdir", "-p", localdir])

# create common folders
execute(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Documents"])
execute(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Downloads"])
execute(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Music"])
execute(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Pictures"])
execute(["sudo", "-u", USER, "mkdir", "-p", homedir + "/Projects"])

# stow dotfiles
os.chdir("/home/" + USER + "/dotfiles")
sp.run(["rm", "/home/" + USER + "/.zshrc"]) #ignore status code
execute(["sudo", "-u", USER, "stow", "alacritty", "compton", "fonts", "zsh", "rofi"])

print("done! :)")