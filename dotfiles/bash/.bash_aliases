# =============================================================================
#  ~/.bash_aliases — NixOS
#  Sections:
#   1.  Safety Nets & Core Overrides
#   2.  Navigation & File Management
#   3.  Listing (eza)
#   4.  Searching & Filtering
#   5.  Archiving & Compression
#   6.  Process & System Monitoring
#   7.  Disk, Memory & Hardware
#   8.  Date & Time
#   9.  Networking
#   10. Web Development & Servers
#   11. Git
#   12. Docker/Podman
#   13. Cryptography & Encoding
#   14. Colourised Commands (grc)
#   15. NixOS Helpers
#   16. Security / CTF — Enumeration
#   17. Security / CTF — Web Application Testing
#   18. Security / CTF — Password Attacks
#   19. Security / CTF — Privilege Escalation
#   20. Security / CTF — Wireless
#   21. Security / CTF — Metasploit
#   22. Security / CTF — Payload Generation
#   23. Security / CTF — Port Forwarding & Tunnelling
#   24. Security / CTF — File Analysis & Steganography
#   25. Security / CTF — Proxy & Anonymity
#   26. Security / CTF — CTF Quick-helpers
#   27. Maintenance & Updates
#   28. Miscellaneous / Fun
# =============================================================================

# =============================================================================
# 1.  SAFETY NETS & CORE OVERRIDES
# =============================================================================

alias cp='cp -vi'                   # Confirm overwrites, show what's copied
alias mv='mv -vi'                   # Confirm overwrites, show what's moved
alias rm='rm -Iv --one-file-system' # Interactive (-I less intrusive), one-fs guard
alias ln='ln -i'                    # Confirm before overwriting a link
alias mkdir='mkdir -pv'             # Create parent dirs automatically, verbose
alias wget='wget -c'                # Resume interrupted downloads by default
alias less='less -FSRXc'            # Quit if short, follow raw colour, no clear on exit
alias path='echo $PATH | tr ":" "\n"' # display path variable vertically
alias cpv='rsync -avh --info=progress2' # Progress-aware copy (better than cp for large files)

# =============================================================================
# 2.  NAVIGATION & FILE MANAGEMENT
# =============================================================================

alias c='clear'
alias e='exit'
alias src='source ~/.bashrc' # Reload shell config

# Jump up N directory levels:  cd -2  →  goes up two levels
cd() {
  if [[ "$1" =~ ^-[0-9]+$ ]]; then
    local n=${1#-} path=""
    for ((i = 0; i < n; i++)); do path+="../"; done
    builtin cd "$path" || return
  else
    builtin cd "$@" || return
  fi
}

alias ..='cd -1'
alias ...='cd -2'
alias ....='cd -3'

alias numFiles='echo $(ls -1 | wc -l)' # Count non-hidden files in current dir
alias hfiles='ls -A | grep "^\."'      # Show only dotfiles
alias hdirs='ls -ld .*/ */'

# Create dummy files of a given size (all zeroes)
alias make1mb='truncate -s 1m ./1MB.dat'
alias make5mb='truncate -s 5m ./5MB.dat'
alias make10mb='truncate -s 10m ./10MB.dat'

# Permissions — shortcuts for common chmod values
alias perm='stat --printf "%a %n\n"' # Show octal permission + name
alias 000='chmod 000'                # ---------- (nobody)
alias 640='chmod 640'                # -rw-r-----
alias 644='chmod 644'                # -rw-r--r--
alias 755='chmod 755'                # -rwxr-xr-x
alias 775='chmod 775'                # -rwxrwxr-x
alias mx='chmod a+x'                 # Make executable for everyone
alias ux='chmod u+x'                 # Make executable for owner only

# Rename all files in CWD — replace extension with .txt
alias rnx='for i in *; do mv "$i" "${i%.*}.txt"; done'

# =============================================================================
# 3.  LISTING  (requires eza)
# =============================================================================

alias ls='eza --icons --git --group-directories-first'
alias ll='eza -l --icons --git --header --group-directories-first'
alias llog='eza -l --icons --git --header -og --group-directories-first'
alias lsa='eza -a --icons --git --group-directories-first'
alias lla='eza -la --icons --git --header --group-directories-first'
alias llaog='eza -la --icons --git --header -og --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias lta='eza -a --tree --level=2 --icons'
alias lt3='eza --tree --level=3 --icons'

# =============================================================================
# 4.  SEARCHING & FILTERING
# =============================================================================

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias qfind='find . -name' # Quick filename search:  qfind "*.log"
alias fzf='fzf --preview "bat --color=always {}"'
alias bat='bat --color=always'

# Find largest files under current directory
alias biggest='du -ah . | sort -rh | head -20'

# Case-insensitive recursive grep shortcut
alias sgrep='grep -rni --color=auto'

# =============================================================================
# 5.  ARCHIVING & COMPRESSION
# =============================================================================

alias tar-ls='tar -tvf'       # List archive contents
alias tar-extract='tar -xvf'  # Extract any tar archive
alias tar-create='tar -cvf'   # Create tar archive
alias tar-gz='tar -czvf'      # Create .tar.gz
alias tar-bz2='tar -cjvf'     # Create .tar.bz2
alias gz-extract='tar -xzvf'  # Extract .tar.gz
alias bz2-extract='tar -xjvf' # Extract .tar.bz2
alias zip-create='zip -r'     # Recursive zip
alias unzip-all='unzip'
alias zcat='zcat' # View gzipped text without extracting

# =============================================================================
# 6.  PROCESS & SYSTEM MONITORING
# =============================================================================

alias h='history'
alias j='jobs -l'

alias ps-all='ps auxf'                          # Full process tree
alias ps-grep='ps aux | grep -v grep | grep -i' # Find process by name:  ps-grep nginx
alias kill9='kill -9'                           # Force-kill by PID
alias pkill-name='pkill -f'                     # Kill by process name pattern

# Top variants
alias topcpu='ps wwaxr -o pid,user,%cpu,time,command | head -15' # Top CPU consumers
alias topmem='ps wwaxr -o pid,user,%mem,rss,command  | head -15' # Top RAM consumers
alias ttop='top -b -n1 | head -30'                               # Single-shot top snapshot

# Continuous monitoring shortcuts
alias iotop='iotop -o'                 # Show only active I/O processes (requires iotop)
alias watch-proc='watch -n1 "ps auxf"' # Refresh process list every second

# =============================================================================
# 7.  DISK, MEMORY & HARDWARE
# =============================================================================

alias df='df -hT --exclude-type=tmpfs --exclude-type=devtmpfs' # Human-readable, skip tmpfs
alias du='du -ch'                                              # Human-readable + grand total
alias duh='du -sh *'                                           # Size of each item in current dir
alias free='free -h'                                           # Human-readable RAM/swap
alias lsblk='lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID'   # Detailed block device list
alias lspci='lspci -v'                                         # Verbose PCI devices
alias lsusb='lsusb -v 2>/dev/null | grep -E "^Bus|iProduct|iManufacturer"'
alias cpuinfo='lscpu'             # CPU architecture summary
alias meminfo='cat /proc/meminfo' # Raw memory info
alias bittype="grep -qP '^flags\s*:.*\blm\b' /proc/cpuinfo && echo 64-bit || echo 32-bit"
alias mountrw='mount -o remount,rw' # Remount a partition read-write:  mountrw /dev/sdX /mnt

# =============================================================================
# 8.  DATE & TIME
# =============================================================================

alias da='date "+%Y-%m-%d %A    %T %Z"'
alias bdate="date '+%a, %b %d %Y %T %Z'"
alias today='date +"%A, %B %-d, %Y"'
alias mytime='date +%H:%M:%S'
alias stamp='date "+%Y%m%d%a%H%M"'
alias timestamp='date "+%Y%m%dT%H%M%S"'
alias epochtime='date +%s'
alias cal3='cal -3'
alias weeknum='date +%V'
alias daysleft='echo "There are $(($(date +%j -d"Dec 31, $(date +%Y)")-$(date +%j))) days left in $(date +%Y)."'

# =============================================================================
# 9.  NETWORKING
# =============================================================================

alias ip='ip -c'          # Coloured ip output
alias ipa='ip -c a'       # Show all interfaces
alias ipr='ip route show' # Routing table
alias ip6='ip -6 -c a'    # IPv6 addresses only

alias myip='curl -s ip-api.com'        # Show public IP + geo info
alias myip-plain='curl -s ifconfig.me' # Just the IP address

alias ports='ss -tulanp'      # Listening ports (ss replaces netstat)
alias netCons='ss -tp'        # Established TCP connections
alias openPorts='ss -tlnp'    # Listening TCP sockets
alias openPortsUDP='ss -ulnp' # Listening UDP sockets

alias lsock='sudo lsof -i -P -n' # All open sockets (lsof)
alias lsockT='sudo lsof -nP | grep TCP'
alias lsockU='sudo lsof -nP | grep UDP'

alias tracert='traceroute'
alias pingg='ping -c5' # Ping with 5 packets:  pingg 8.8.8.8

alias flushDNS='sudo resolvectl flush-caches' # Flush systemd-resolved DNS cache
alias showDNS='resolvectl status'

alias pserv='python3 -m http.server 8000' # Quick HTTP server on port 8000
alias showpath='echo "$PATH" | tr ":" "\n" | sort'
alias show_options='shopt'

# =============================================================================
# 10.  WEB DEVELOPMENT & SERVERS
# =============================================================================

alias editHosts='sudo nano /etc/hosts'

# Systemd service management for web servers
alias nginx-edit='sudo nano /etc/nginx/nginx.conf'
alias nginx-restart='sudo systemctl restart nginx'
alias nginx-test='sudo nginx -t'
alias nginx-logs='sudo journalctl -u nginx -f'

alias ssh-restart='sudo systemctl restart sshd'
alias ssh-status='sudo systemctl status sshd'

# Tail common logs
alias tail-auth='sudo journalctl -u systemd-logind -f'
alias tail-syslog='sudo journalctl -f'
alias tail-kern='sudo journalctl -k -f'

# =============================================================================
# 11.  GIT
# =============================================================================

alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gstp='git stash pop'
alias gitup='git add . && git commit -m "updated" && git push' # Quick commit + push

# =============================================================================
# 12.  DOCKER/PODMAN
# =============================================================================

alias dps='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'                      # Exec into container:  dex <name> bash
alias dlogs='docker logs -f'                     # Follow container logs
alias dstop='docker stop $(docker ps -q)'        # Stop all running containers
alias drm='docker rm $(docker ps -aq)'           # Remove all stopped containers
alias drmi='docker rmi $(docker images -q)'      # Remove all images
alias dprune='docker system prune -af --volumes' # Full clean
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'

# Podman alternatives
alias pps='podman ps -a'
alias pex='podman exec -it'
alias pstop='podman stop $(podman ps -q)'
alias pprune='podman system prune -af'

# =============================================================================
# 13.  CRYPTOGRAPHY & ENCODING
# =============================================================================

alias openssl-enc='openssl enc -aes-256-ctr -pbkdf2 -e -a -in /dev/stdin -out encrypted_file.txt'
alias openssl-dec='openssl enc -aes-256-ctr -pbkdf2 -d -a -in /dev/stdin -out decrypted_file.txt'

# Classic cipher rotations (pipe text into them)
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias rot18="tr 'A-Za-z0-9' 'N-ZA-Mn-za-m5-90-4'"
alias rot47="tr '\!-~' 'P-~\!-O'"

alias base64-enc='base64'
alias base64-dec='base64 -d'
alias xxd-view='xxd'           # Hex dump a file:  xxd-view file.bin | less
alias strings-all='strings -a' # Extract printable strings from binary

# =============================================================================
# 14.  COLOURISED COMMANDS  (requires grc)
# =============================================================================

GRC="$(command -v grc)"
if tty -s && [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && [ -n "$GRC" ]; then
  alias colourify="$GRC -es --colour=auto"

  alias blkid='colourify blkid'
  alias configure='colourify ./configure'
  alias diff='colourify diff'
  alias docker='colourify docker'
  alias docker-compose='colourify docker-compose'
  alias df='colourify df -hT --exclude-type=tmpfs --exclude-type=devtmpfs'
  alias du='colourify du -ch'
  alias fdisk='colourify fdisk'
  alias findmnt='colourify findmnt'
  alias free='colourify free -h'
  alias gcc='colourify gcc'
  alias g++='colourify g++'
  alias id='colourify id'
  alias ifconfig='colourify ifconfig'
  alias iptables='colourify iptables'
  alias ip='colourify ip -c'
  alias journalctl='colourify journalctl'
  alias kubectl='colourify kubectl'
  alias lsblk='colourify lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID'
  alias lsof='colourify lsof'
  alias lspci='colourify lspci'
  alias make='colourify make'
  alias mount='colourify mount'
  alias mtr='colourify mtr'
  alias netstat='colourify netstat'
  alias nmap='colourify nmap'
  alias ping='colourify ping'
  alias ps='colourify ps'
  alias ss='colourify ss'
  alias stat='colourify stat'
  alias tail='colourify tail'
  alias traceroute='colourify traceroute'
  alias traceroute6='colourify traceroute6'
  alias w='colourify w'
  alias whois='colourify whois'
  alias who='colourify who'
fi

# =============================================================================
# 15.  NIXOS HELPERS
# =============================================================================

# NixOS system management
alias nsw='sudo nixos-rebuild switch'
alias nbd='sudo nixos-rebuild build'
alias nts='sudo nixos-rebuild test'
alias ndr='sudo nixos-rebuild dry-build'
alias nbt='sudo nixos-rebuild boot'

# Nix package management
alias nsr='nix search nixpkgs'
alias nin='nix-env -iA nixpkgs'
alias nrm='nix-env -e'
alias nls='nix-env -q'
alias nup='nix-env -u'
alias ngc='nix-collect-garbage'
alias ngo='nix-collect-garbage --delete-older-than 30d'
alias nso='nix-store --optimise'
alias nsh='nix-shell --run bash'

# Flakes
alias nfu='nix flake update'
alias nfc='nix flake check'

# Nix development shells
alias ndv='nix develop'

# Systemd shortcuts
alias sctl='sudo systemctl'
alias scts='sudo systemctl status'
alias sctr='sudo systemctl restart'
alias sctt='sudo systemctl start'
alias sctsp='sudo systemctl stop'
alias scte='sudo systemctl enable'
alias sctsd='sudo systemctl disable'
alias sctlr='sudo systemctl daemon-reload'
alias fail='systemctl --failed'
alias jrn='sudo journalctl -xe'
alias jrnb='sudo journalctl -b'
alias jrnu='journalctl --user'

# User & group management
alias grps='groups | xargs -n1 | sort'
alias lstl='last -n 20'
alias flog='sudo lastb -n 20'
alias wtf='who -a'

# SSH
alias kgen='ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"'
alias kscp='ssh-copy-id'
alias kls='ls -la ~/.ssh/'
alias khs='cat ~/.ssh/known_hosts'
alias rmkh='ssh-keygen -R'

# Quick system info
alias info='uname -a && echo "NixOS $(nixos-version)"'
alias ff='fastfetch'
alias btype="grep -qP '^flags\s*:.*\blm\b' /proc/cpuinfo && echo 64-bit || echo 32-bit"

# Certificates
alias sslc='openssl x509 -text -noout -in'
alias sslr='openssl s_client -connect'

# NixOS generations
alias ngs='sudo nix-env --list-generations --profile /nix/var/nix/profiles/system'
alias nrb='sudo nixos-rebuild switch --rollback'

# Hardware info shortcuts
alias hdtp='sudo hddtemp /dev/sd?' 2>/dev/null || echo 'Install hddtemp package'
alias ctmp='cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | awk "{print \$1/1000 \"°C\"}"'

# Screen / tmux helpers
alias ta='tmux attach || tmux new'
alias tls='tmux ls'
alias tn='tmux new -s'

# Notes
alias note='mkdir -p ~/notes && "${EDITOR:-nano}" ~/notes/$(date +%Y%m%d).md'
alias notes='ls -lt ~/notes/'

# =============================================================================
# 16.  SECURITY / CTF — ENUMERATION
# =============================================================================

# Nmap
alias nmap-fast='nmap -F -T5 --open'
alias nmap-full='nmap -sS -sU -T4 -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53'
alias nmap-os='sudo nmap -O --osscan-guess'
alias nmap-ping='nmap -sn'
alias nmap-vuln='sudo nmap --script vuln'
alias nmap-smb='nmap -p 445 --script=smb-enum-shares,smb-enum-users,smb-vuln-ms17-010'
alias nmap-http='nmap -p 80,443,8080,8443 --script=http-enum,http-title'
alias nmap2xml='sudo nmap -sS -T4 -A -sC -oX nmap.xml'
alias xml2html='xsltproc -o nmap.html nmap-bootstrap.xsl nmap.xml'
alias nmap-top='nmap --top-ports 1000 -T4 -v'

# SMB / Windows enumeration
alias smb-enum='enum4linux -a'
alias smb-client='smbclient -L'
alias smb-map='smbmap -H'
alias crackmapexec-smb='crackmapexec smb'

# DNS enumeration
alias dns-enum='dnsenum --enum'
alias dnsrecon-scan='dnsrecon -d'
alias dig-all='dig any'
alias dig-axfr='dig axfr'

# SNMP
alias snmp-check='snmp-check'
alias snmp-walk='snmpwalk -c public -v1'
alias onesixtyone-scan='onesixtyone -c /usr/share/wordlists/snmp-strings.txt'

# RPC / FTP / SMTP quick checks
alias rpc-enum='rpcinfo -p'
alias ftp-anon='ftp -n'
alias smtp-test='nc -nv'

# Network discovery
alias netdiscover-scan='sudo netdiscover -r'
alias arp-scan='sudo arp-scan -l'

# GTFOBins lookups
alias wads='gtfoblookup wadcoms search'
alias wadl='gtfoblookup wadcoms list'
alias hijacks='gtfoblookup hijacklibs search'
alias hijackl='gtfoblookup hijacklibs list'
alias gtfobs='gtfoblookup gtfobins search'
alias gtfobl='gtfoblookup gtfobins list'

# =============================================================================
# 17.  SECURITY / CTF — WEB APPLICATION TESTING
# =============================================================================

alias gobuster-dir='gobuster dir -w /usr/share/wordlists/dirb/common.txt -t 50'
alias gobuster-vhost='gobuster vhost -w /usr/share/wordlists/dirb/common.txt -t 50'
alias gobuster-dns='gobuster dns -w /usr/share/wordlists/dirb/common.txt -t 50'
alias nikto-scan='nikto -h'
alias wfuzz-scan='wfuzz -c -z file,/usr/share/wordlists/dirb/common.txt --hc 404'
alias sqlmap-auto='sqlmap --batch --random-agent --level=3'
alias ffuf-scan='ffuf -w /usr/share/wordlists/dirb/common.txt -u'

# curl helpers
alias curl-headers='curl -sI'
alias curl-follow='curl -sL'
alias curl-time='curl -s -w "DNS: %{time_namelookup}s  Connect: %{time_connect}s  Total: %{time_total}s\n" -o /dev/null'

# =============================================================================
# 18.  SECURITY / CTF — PASSWORD ATTACKS
# =============================================================================

alias john-basic='john --format=raw-md5'
alias john-show='john --show'
alias hashcat-md5='hashcat -m 0 -a 0'
alias hashcat-sha1='hashcat -m 100 -a 0'
alias hashcat-ntlm='hashcat -m 1000 -a 0'
alias hashcat-sha256='hashcat -m 1400 -a 0'
alias rockyou='john --wordlist=/usr/share/wordlists/rockyou.txt'
alias hydra-ssh='hydra -L /usr/share/wordlists/common_users.txt -P /usr/share/wordlists/rockyou.txt ssh://'
alias hydra-http='hydra -L users.txt -P /usr/share/wordlists/rockyou.txt http-post-form'

# Hash identification
alias hash-id='hashid'
alias hash-id2='hash-identifier'

# =============================================================================
# 19.  SECURITY / CTF — PRIVILEGE ESCALATION
# =============================================================================

alias linpeas='curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh'
alias winpeas='curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat'
alias pspy64='curl -sL https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -o /tmp/pspy64 && chmod +x /tmp/pspy64 && /tmp/pspy64'
alias suid-find='find / -perm -u=s -type f 2>/dev/null'
alias sgid-find='find / -perm -g=s -type f 2>/dev/null'
alias world-write='find / -perm -o+w -type f 2>/dev/null'
alias cap-find='getcap -r / 2>/dev/null'
alias sudo-list='sudo -l'

# =============================================================================
# 20.  SECURITY / CTF — WIRELESS
# =============================================================================

alias wifi-list='nmcli dev wifi list'
alias wifi-mon='sudo airmon-ng start'
alias airodump='sudo airodump-ng -w capture --output-format pcap,csv -K 1'
alias aireplay-deauth='sudo aireplay-ng --deauth 10 -a'
alias airgeddon='sudo bash /usr/share/airgeddon/airgeddon.sh'

# =============================================================================
# 21.  SECURITY / CTF — METASPLOIT
# =============================================================================

alias msfconsole='msfconsole -q'
alias msfrpc='msfrpcd -U msf -P password -f -S'
alias msfvenom-list='msfvenom -l'
alias msfvenom-list-payloads='msfvenom -l payloads'
alias msfvenom-list-encoders='msfvenom -l encoders'

# =============================================================================
# 22.  SECURITY / CTF — PAYLOAD GENERATION
# =============================================================================

alias msfvenom-exe='msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST= LPORT= -f exe -o'
alias msfvenom-elf='msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST= LPORT= -f elf -o'
alias msfvenom-apk='msfvenom -p android/meterpreter/reverse_tcp LHOST= LPORT= -o'
alias msfvenom-ps1='msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST= LPORT= -f psh -o'

# File transfer servers
alias http-server='python3 -m http.server 8080'
alias ftp-server='python3 -m pyftpdlib -p 2121 -w'
alias smb-server='impacket-smbserver -smb2support share .'

# =============================================================================
# 23.  SECURITY / CTF — PORT FORWARDING & TUNNELLING
# =============================================================================

alias ssh-local='ssh -L'
alias ssh-remote='ssh -R'
alias ssh-dynamic='ssh -D 1080 -qCN'
alias socat-listen='socat TCP-LISTEN:'
alias chisel-client='chisel client'

# =============================================================================
# 24.  SECURITY / CTF — FILE ANALYSIS & STEGANOGRAPHY
# =============================================================================

alias file-check='file'
alias hexdump='xxd'
alias hexdump-less='xxd | less'
alias exif-all='exiftool'
alias steg-extract='steghide extract -sf'
alias binwalk-all='binwalk -e'
alias foremost-run='foremost -i'

# =============================================================================
# 25.  SECURITY / CTF — PROXY & ANONYMITY
# =============================================================================

alias mproxy='curl --proxy http://127.0.0.1:8080'
alias start-tor='sudo systemctl start tor'
alias stop-tor='sudo systemctl stop tor'
alias check-tor='curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip'
alias proxychains-quiet='proxychains -q'

# =============================================================================
# 26.  SECURITY / CTF — CTF QUICK-HELPERS
# =============================================================================

# Classic ciphers
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

# Caesar brute-force all 25 shifts
caesar-brute() {
  local msg="${*:-$(cat)}"
  for i in $(seq 1 25); do
    printf "ROT%02d: %s\n" "$i" "$(echo "$msg" | tr 'A-Za-z' "$(python3 -c "
import string; n=$i
u=string.ascii_uppercase; l=string.ascii_lowercase
print(u[n:]+u[:n]+l[n:]+l[:n])")")"
  done
}

# Single-byte XOR decoder
xor-byte() {
  python3 -c "
import sys
data=open(sys.argv[1],'rb').read(); key=int(sys.argv[2],0)
print(bytes([b^key for b in data]))" "$@"
}

# Asciinema screen recording
alias trec='asciinema rec'
alias tplay='asciinema play'

# cheat sheets
alias cheat='tldr'

# Quick evidence directory
alias evidence='mkdir -p ~/evidence && cd ~/evidence && ls -la'

# yt-dlp
alias ydlp='yt-dlp -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"'
alias ydlc='yt-dlp -o "%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"'

# Kernel modules
alias lload="find /run/current-system/kernel-modules/lib/modules/$(uname -r) -type f -name '*.ko*'"

# =============================================================================
# 27.  MAINTENANCE & UPDATES
# =============================================================================

# Full system upgrade with NixOS
alias update='sudo nixos-rebuild switch --upgrade \
    && nix-collect-garbage --delete-older-than 30d \
    && tldr --update \
    && ble-update \
    && atuin sync \
    && figlet "NixOS Updated!" | lolcat'

alias update-full='sudo nixos-rebuild switch --upgrade \
    && nix-collect-garbage --delete-older-than 7d \
    && nix-store --optimise \
    && sudo fstrim -v \
    && tldr --update \
    && ble-update \
    && atuin sync \
    && figlet "System Optimized!" | lolcat'

# Clean old generations
alias clng='sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system'
alias cln30='sudo nix-collect-garbage --delete-older-than 30d'
alias clnall='sudo nix-collect-garbage -d'

alias clearhistory='echo "" > ~/.bash_history && history -c \
    && { command -v atuin &>/dev/null && atuin search --delete-it-all; true; }'

# =============================================================================
# 28.  MISCELLANEOUS / FUN
# =============================================================================

alias matrix='cmatrix -r'
alias starwars='telnet towel.blinkenlights.nl'
alias themes='kitty +kitten themes'
alias cal='ncal -b'
alias weather='curl wttr.in'
alias weather-short='curl "wttr.in/?format=3"'
alias cheat-sheet='curl cheat.sh/'

# =============================================================================
