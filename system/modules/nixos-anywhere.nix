{ pkgs, config, ... }:
let
  nixos-remote-deploy = let
    pubKey = (builtins.elemAt config.age.rekey.masterIdentities 0).identity;
    secretsDir = config.age.secretsDir;
  in pkgs.writeShellScript "nixos-remote-deploy.sh" ''
    #!/usr/bin/env bash
    
    # Ensure hostname and IP are provided as arguments
    if [ "$#" -ne 2 ]; then
      echo "Usage: $0 <hostname> <ip>"
      exit 1
    fi
    
    # Assign arguments to variables
    hostname="$1"
    ip="$2"
    
    # Create a temporary directory
    temp=$(mktemp -d)
    
    # Function to cleanup temporary directory on exit
    cleanup() {
      rm -rf "$temp"
    }
    trap cleanup EXIT
    
    # Create the directory where sshd expects to find the host keys
    install -d -m755 "$temp/persist/system/etc/ssh"
    
    # Decrypt your private key from the password store and copy it to the temporary directory
    ${pkgs.rage}/bin/rage -d -i ${pubKey} ${secretsDir}/ssh_$hostname > "$temp/persist/system/etc/ssh/ssh_host_ed25519_key"
    
    # Set the correct permissions so sshd will accept the key
    chmod 600 "$temp/persist/system/etc/ssh/ssh_host_ed25519_key"
    
    # Install NixOS to the host system with our secrets
    nix run github:nix-community/nixos-anywhere -- \
      --disk-encryption-keys /tmp/luks.key <(${pkgs.rage}/bin/rage -d -i ${pubKey} ${luksKey}) \
      --extra-files "$temp" \
      --flake ".#$hostname" \
      --target-host "nixos@$ip"
  '';
in
{
  environment.systemPackages = [ nixos-remote-deploy ];
}
