# DPS
## Debian postinstall script with Gnome

### Usage:
1. Load the pressed file https://wiki.debian.org/DebianInstaller/Preseed#Loading_the_preseeding_file_from_a_webserver
2. Install Debian stable or testing
3. Run the following command:
   ```bash
   wget -O - https://raw.githubusercontent.com/aattilam/dps/main/setup.sh | sudo bash
   ```
4. At the end of the script, answer "y" if you want to install additional software.
5. The script will reboot and you will be prompted to create an account.
