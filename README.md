# DPS
## Debian postinstall script with Gnome
### Usage:

#### Method 1:
1. Load the pressed file https://wiki.debian.org/DebianInstaller/Preseed#Loading_the_preseeding_file_from_a_webserver
   - In the boot menu select **Help**
   - Look for the the **boot** prompt at the bottom
   - Type "auto url=https://raw.githubusercontent.com/aattilam/dps/main/preseed.cfg"
   - Press enter
2. Install Debian stable or testing
3. The installer will reboot and you will be prompted to create an account.


#### Method 2:
1. Install debian manually
2. Run the script
   ```bash
   wget -O - https://raw.githubusercontent.com/aattilam/dps/main/setup.sh | sudo bash
   ```
