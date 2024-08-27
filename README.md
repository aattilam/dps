# DPS
## Debian postinstall script with Gnome

### Usage:
1. Load the pressed file https://wiki.debian.org/DebianInstaller/Preseed#Loading_the_preseeding_file_from_a_webserver
   - In the graphical installer boot menu select **Help**
   - Click on the **boot** promt at the bottom
   - Type "auto url=https://raw.githubusercontent.com/aattilam/dps/main/preseed.cfg debian-installer/allow_unauthenticated_ssl=true"
2. Install Debian stable or testing
3. Restart and then login with root account (password is root)
4. Run the following command:
   ```bash
   wget -O - https://raw.githubusercontent.com/aattilam/dps/main/setup.sh | sudo bash
   ```
5. At the end of the script, answer "y" if you want to install additional software.
6. The script will reboot and you will be prompted to create an account.
