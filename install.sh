echo "Installing window-title-applet"
rm -rf ~/.local/share/plasma/plasmoids/org.kde.windowtitle
cp -r ./ ~/.local/share/plasma/plasmoids/org.kde.windowtitle
systemctl --user restart plasma-plasmashell
echo "Installed window-title-applet"
