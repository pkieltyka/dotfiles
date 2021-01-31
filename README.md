put your hashed password into /etc/nixos/hashedPassword.nix
you can get this with mkpasswd

run `setup.sh` to make the symlinks you need, then run `home-manager switch`.

system level config in `configuration.nix`, user-level config in `nixpkgs/home.nix`


-----------

1. Install nixos, see..

2. default config? we have laptop and have desktop.. needs some tweaking for hardware profile..

3. git clone https://github.com/pkieltyka/dotfiles /home/peter/.dotfiles

4. ln -s /home/peter/.dotfiles/configuration.nix /etc/nixos/configuration.nix

5. add nixos-unstable channel........

6. home-manager, add the channel, etc.. nix-channel --update

7. ln -s /home/peter/.dotfiles/.bin /home/peter/.bin

8. we need i3-powertools.. should be a nixpkg ..

9. when to copy ssh keys...?

10. wallpapers.. can keep in dotfiles too.. or from backup?

11. ~peter/.config files..? like vscode, etc.? perhaps we have backup paths or something..? or, config/vscode/ linnk to ~/.config/Code/User

12. i3status, temperature..?
