# HTB_vpn_over_vpn
For those who has established successful connection to HTB server but has no response form it

## That is one of the ways to solve such kind of problem with connection to HTB. It was tested on Kali Linux 2025.2
First of all, run your vpn. It must create new interface. For this example it will be tun0.
Next step is to get your .ovpn file and specify the file name on line 36 in `run_vpn2_over_vpn1.sh` instead of `file.ovpn`.
Run the edited script with sudo rights and get root shell. The logic scheme looks like `[You] → VPN1 → VPN2 (into namespace, HTB) → Internet`
