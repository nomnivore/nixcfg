#!/usr/bin/env bash

# A semi-interactive script for NixOS pre-installation tasks
# (Partitioning, Formatting, and Initial Mounting)

# --- Terminal Color Variables ---
RED=$'\e[31m'    # For Errors and Warnings
GREEN=$'\e[32m'  # For Success and Main Headers/Highlighting
YELLOW=$'\e[33m' # For Notes and Prompts
CYAN=$'\e[36m'   # For Step Headers
RESET=$'\e[0m'   # Resets text color and formatting
# --------------------------------

# --- Helper Functions ---

# Function to safely exit on error
function check_status {
    if [ $? -ne 0 ]; then
        echo -e "\n${RED}[ERROR]${RESET} The last command failed. Please check the output above and resolve the issue before continuing."
        read -p "Press [Enter] to continue (or Ctrl+C to exit script)..."
    fi
}

# Function to get user input with a default value
function get_user_input {
    local prompt="$1"
    local default_value="$2"
    local result=""

    # Display prompt with default value, using GREEN for emphasis
    read -r -p "$prompt [Default: ${GREEN}$default_value${RESET}]: " result

    # Check if result is empty and use default if so
    if [ -z "$result" ]; then
        echo "$default_value"
    else
        echo "$result"
    fi
}

# --- Configuration Variables ---
BOOT_SIZE="512MB"
BOOT_LABEL="boot"
ROOT_LABEL="nixos"
SWAP_LABEL="swap"
# SWAP_SIZE and ROOT_SIZE will be set dynamically below
# -----------------------------

# --- CRITICAL: Check for root user permissions ---
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[FATAL ERROR]${RESET} This script must be run as root."
  echo "Please run with 'sudo ./nixos-setup.sh' or run as the root user."
  exit 1
fi
# ------------------------------------------------

echo -e "${GREEN}--- NixOS Partitioning and Formatting Assistant ---${RESET}"
echo -e "This script will guide you through the initial setup steps for installing NixOS."
echo -e "NOTE: This script uses ${YELLOW}parted${RESET} for partitioning."
echo "---------------------------------------------------"

# 1. Find the target disk
echo -e "\n${CYAN}[STEP 1]${RESET} Determine the target disk."
echo "Running 'lsblk' to show available disks:"
lsblk
echo -e "${RED}WARNING:${RESET} Be absolutely sure of the device name, as this will erase all data!"
read -r -p "Enter the target disk device (e.g., /dev/sda, sda, /dev/nvme0n1): " DISK_INPUT

# If the input doesn't start with a slash, prepend /dev/
if [[ ! "$DISK_INPUT" =~ ^/ ]]; then
    DISK="/dev/$DISK_INPUT"
else
    DISK="$DISK_INPUT"
fi
# ----------------------------------

# Display the final resolved disk path as confirmation
echo -e "Target disk selected: ${GREEN}$DISK${RESET}"

if [ ! -b "$DISK" ]; then
    echo -e "${RED}[FATAL ERROR]${RESET} Device '$DISK' not found or is not a block device. Exiting."
    exit 1
fi

# 1.5. Determine swap configuration
echo -e "\n${CYAN}[STEP 1.5]${RESET} Determine swap configuration."
SWAP_INPUT=$(get_user_input "Enter desired SWAP size (e.g., 8GB, 4G, 0 for no swap): " "8GB")
SWAP_SIZE=$(echo "$SWAP_INPUT" | tr '[:lower:]' '[:upper:]') # Normalize to uppercase for size

SHOULD_CREATE_SWAP=true
if [[ "$SWAP_SIZE" == "0" || "$SWAP_SIZE" == "0GB" || "$SWAP_SIZE" == "0B" ]]; then
    SHOULD_CREATE_SWAP=false
    echo "Swap creation disabled. Root partition will use remaining disk space."
    ROOT_SIZE="100%" # Root partition fills everything after the boot partition
    # Ensure SWAP_SIZE is set to 0 for display purposes later
    SWAP_SIZE="0" 
else
    # Use negative size for parted: means the space remaining before $SWAP_SIZE from the end.
    ROOT_SIZE="-${SWAP_SIZE}" 
fi

# 2. Select Boot Mode
echo -e "\n${CYAN}[STEP 2]${RESET} Select Boot Mode."
echo "1) ${GREEN}UEFI${RESET} (Recommended) - Uses GPT partitioning."
echo "2) ${GREEN}Legacy Boot${RESET} (BIOS) - Uses MBR (msdos) partitioning."
# --- CHANGE: Set default boot mode to 1 (UEFI)
BOOT_MODE=$(get_user_input "Enter your choice (1 or 2)" "1")
# --------------------------------------------

# 3. Partitioning
echo -e "\n${CYAN}[STEP 3]${RESET} Starting Partitioning on ${GREEN}$DISK${RESET}."
echo "ALL DATA ON ${RED}$DISK${RESET} WILL BE ERASED."
read -r -p "Confirm (type 'YES' to proceed with partitioning): " CONFIRM_PARTITION

# Check for 'YES' case-insensitively
if [[ "${CONFIRM_PARTITION^^}" != "YES" ]]; then
    echo "Partitioning cancelled by user. Exiting."
    exit 0
fi

if [ "$BOOT_MODE" == "1" ]; then
    # UEFI (GPT) Partitioning
    echo -e "\n--- UEFI (GPT) Partitioning ---"
    echo "Creating GPT table, ESP (boot), and root partitions."
    
    # 1. Create GPT label
    parted "$DISK" -- mklabel gpt
    check_status

    # 2. Create ESP (boot) partition (always partition 1)
    parted "$DISK" -- mkpart ESP fat32 1MB "$BOOT_SIZE"
    check_status

    # 3. Create root and optionally swap
    if $SHOULD_CREATE_SWAP ; then
        echo "Creating root and swap partitions..."
        
        # Create root partition (partition 2)
        parted "$DISK" -- mkpart root ext4 "$BOOT_SIZE" "$ROOT_SIZE"
        check_status

        # Create swap partition (partition 3)
        parted "$DISK" -- mkpart swap linux-swap "$ROOT_SIZE" 100%
        check_status

        # Set partition variables for formatting
        BOOT_PART="${DISK}1"
        ROOT_PART="${DISK}2"
        SWAP_PART="${DISK}3"
    else
        echo "Creating root partition (no swap)..."
        
        # Create root partition (partition 2)
        parted "$DISK" -- mkpart root ext4 "$BOOT_SIZE" 100%
        check_status
        
        # Set partition variables for formatting
        BOOT_PART="${DISK}1"
        ROOT_PART="${DISK}2"
        SWAP_PART=""
    fi

    # 4. Set 'esp' flag on ESP partition (partition 1)
    parted "$DISK" -- set 1 esp on
    check_status

elif [ "$BOOT_MODE" == "2" ]; then
    # Legacy Boot (MBR) Partitioning
    echo -e "\n--- Legacy Boot (MBR) Partitioning ---"
    echo "Creating MBR table, root, and optionally swap partitions."

    # 1. Create MBR label
    parted "$DISK" -- mklabel msdos
    check_status

    # 2. Create root and optionally swap
    if $SHOULD_CREATE_SWAP ; then
        echo "Creating root and swap partitions..."

        # Create root partition (partition 1)
        parted "$DISK" -- mkpart primary 1MB "$ROOT_SIZE"
        check_status

        # Create swap partition (partition 2)
        parted "$DISK" -- mkpart primary linux-swap "$ROOT_SIZE" 100%
        check_status
        
        # Set partition variables for formatting
        ROOT_PART="${DISK}1"
        SWAP_PART="${DISK}2"
        BOOT_PART="" # Not needed for Legacy/MBR separate formatting
    else
        echo "Creating root partition (no swap)..."

        # Create root partition (partition 1)
        parted "$DISK" -- mkpart primary 1MB 100%
        check_status
        
        # Set partition variables for formatting
        ROOT_PART="${DISK}1"
        SWAP_PART=""
        BOOT_PART=""
    fi

    # 3. Set 'boot' flag on root partition (partition 1)
    parted "$DISK" -- set 1 boot on
    check_status

else
    echo -e "${RED}[FATAL ERROR]${RESET} Invalid boot mode selected. Exiting."
    exit 1
fi

# List final partitions to check device names
echo -e "\nPartitions created. Running ${GREEN}lsblk -f $DISK${RESET} to confirm names:"
lsblk -f "$DISK"

echo -e "\n${YELLOW}Please confirm the device names printed above are correct for formatting.${RESET}"
read -r -p "Press [Enter] to continue with formatting..."

# 4. Formatting
echo -e "\n${CYAN}[STEP 4]${RESET} Starting Formatting."

# 4.1. Format Root partition
echo "Formatting root partition (${GREEN}$ROOT_PART${RESET}) as Ext4 with label '${GREEN}$ROOT_LABEL${RESET}'..."
mkfs.ext4 -L "$ROOT_LABEL" "$ROOT_PART"
check_status

# 4.2. Format Swap partition (Conditional)
if $SHOULD_CREATE_SWAP ; then
    echo "Formatting swap partition (${GREEN}$SWAP_PART${RESET}) with label '${GREEN}$SWAP_LABEL${RESET}' and activating swap..."
    mkswap -L "$SWAP_LABEL" "$SWAP_PART"
    check_status
    swapon "$SWAP_PART"
    check_status
else
    echo "Swap partition skipped as requested (size: $SWAP_SIZE)."
fi

# 4.3. Format Boot partition (UEFI only)
if [ "$BOOT_MODE" == "1" ]; then
    echo "Formatting boot partition (${GREEN}$BOOT_PART${RESET}) as FAT32 with label '${GREEN}$BOOT_LABEL${RESET}'..."
    mkfs.fat -F 32 -n "$BOOT_LABEL" "$BOOT_PART"
    check_status
fi

# 5. Mounting
echo -e "\n${CYAN}[STEP 5]${RESET} Mounting Partitions."

# 5.1. Mount Root
echo "Creating mount point /mnt and mounting root partition..."
mkdir -p /mnt
mount "/dev/disk/by-label/$ROOT_LABEL" /mnt
check_status

# 5.2. Mount Boot (UEFI only)
if [ "$BOOT_MODE" == "1" ]; then
    echo "Creating mount point /mnt/boot and mounting boot (ESP) partition..."
    mkdir -p /mnt/boot
    mount -o umask=077 "/dev/disk/by-label/$BOOT_LABEL" /mnt/boot
    check_status
fi

# 6. Next Steps and Final Check
echo -e "\n${GREEN}--- INITIAL SETUP COMPLETE ---${RESET}"

# Show final partition details (Label, Size, Path)
echo -e "\n${CYAN}[FINAL PARTITION DETAILS]${RESET}"
echo "---------------------------------------------------"
# Use lsblk to display all relevant info for the formatted partitions on the target disk
lsblk -o NAME,SIZE,LABEL,FSTYPE,MOUNTPOINT "$DISK" | grep -E "${ROOT_LABEL}|${SWAP_LABEL}|${BOOT_LABEL}"
echo "---------------------------------------------------"


echo "Your partitions are formatted and mounted on /mnt. Swap is active (if created)."
echo -e "\n${CYAN}[NEXT STEPS]${RESET}"
echo "1. Generate your configuration:"
echo -e "   ${GREEN}nixos-generate-config --root /mnt${RESET}"
echo "2. Edit the configuration file (${GREEN}vim /mnt/etc/nixos/configuration.nix${RESET}, etc.)."
echo "3. Run the installer: ${GREEN}nixos-install${RESET}"
echo "---------------------------------------------------"
