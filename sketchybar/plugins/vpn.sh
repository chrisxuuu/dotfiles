#!/bin/bash

# Check for different types of VPN connections
VPN=""

# 1. Check standard macOS VPN connections first
VPN=$(scutil --nc list | grep Connected | sed -E 's/.*"(.*)".*/\1/')

# 2. Check for Cisco Secure Client (newer version)
if [[ $VPN == "" ]]; then
  # Check if Cisco Secure Client is running
  if pgrep -f "Cisco Secure Client" > /dev/null; then
    # Try the new Cisco Secure Client CLI path
    if command -v "/Applications/Cisco/Cisco Secure Client.app/Contents/MacOS/Cisco Secure Client" >/dev/null 2>&1; then
      # For Cisco Secure Client, we need to check differently
      # Check if VPN interface exists and is being used by Cisco
      VPN_ROUTE=$(route get default 2>/dev/null | grep interface | grep utun)
      if [[ $VPN_ROUTE != "" ]]; then
        VPN="Cisco Secure Client"
      fi
    fi
  fi
fi

# 3. Check for legacy Cisco AnyConnect
if [[ $VPN == "" ]]; then
  if pgrep -f "Cisco AnyConnect" > /dev/null; then
    if command -v /opt/cisco/anyconnect/bin/vpn >/dev/null 2>&1; then
      CISCO_STATUS=$(echo "state" | /opt/cisco/anyconnect/bin/vpn -s 2>/dev/null | grep "Connected")
      if [[ $CISCO_STATUS == *"Connected"* ]]; then
        CISCO_SERVER=$(echo "$CISCO_STATUS" | sed 's/.*Connected to //' | awk '{print $1}')
        VPN="$CISCO_SERVER"
      fi
    fi
  fi
fi

# 4. Check for other VPN applications
if [[ $VPN == "" ]]; then
  if pgrep -f "openvpn\|vpnc\|strongswan" > /dev/null; then
    VPN_INTERFACE=$(route get default 2>/dev/null | grep interface | grep utun)
    if [[ $VPN_INTERFACE != "" ]]; then
      VPN="OpenVPN"
    fi
  fi
fi

# Display VPN status
if [[ $VPN != "" ]]; then
  sketchybar --set "$NAME" icon="󰖂" \
                          label="$VPN" \
                          drawing=on \
                          icon.color=0xff4ade80 \
                          label.color=0xffffffff
else
  sketchybar --set "$NAME" drawing=off
fi