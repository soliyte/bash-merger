#!/usr/bin/env bash
set -e

while getopts r:c: flag
do
    case "${flag}" in
        r) RUN_DIR_FLAG=${OPTARG};;
        c) CONFIG_FLAG=${OPTARG};;
        *) echo "Invalid option";;
    esac
done

CURRENT_DIR=$(pwd)
DEFAULT_CONFIG_FILE="merge-config.sh"

# Check if the run directory is provided if not use the current directory
if [ -z "$RUN_DIR_FLAG" ]; then
  RUN_DIR_FLAG=$CURRENT_DIR
fi

# Check if the config file is provided if not use the default config file
if [ -z "$CONFIG_FLAG" ]; then
  CONFIG_FLAG=$RUN_DIR_FLAG/$DEFAULT_CONFIG_FILE
fi

RUN_DIR=$(realpath "$RUN_DIR_FLAG")

# Check if the directory exists
if [ ! -d "$RUN_DIR" ]; then
  # If no directory is provided use the current directory
  RUN_DIR=$CURRENT_DIR
  
  if [ ! -d "$RUN_DIR" ]; then
    echo "Directory $RUN_DIR does not exist"
    echo "Please provide a valid directory"
    echo ""
    echo "Example: ./merge.sh -r /path/to/directory"
    exit 1
  fi
fi

CONFIG=$(realpath "$CONFIG_FLAG")

# Check if the config file exists
if [ -n "$CONFIG" ] && [ ! -f "$CONFIG" ]; then
  # If no config file is provided use the default config file
  CONFIG=$RUN_DIR/merger-merge-config.sh
  
  if [ ! -f "$CONFIG" ]; then
    echo "File $CONFIG does not exist"
    echo "Please provide a valid config file"
    echo ""
    echo "Example: ./merge.sh -c /path/to/config.sh"
    exit 1
  fi
fi

# Load the config file
# shellcheck disable=SC1090
source "$CONFIG"

echo "Merging $RUN_DIR"

# Set OUT_DIR related to the run directory
REAL_OUT_DIR="$RUN_DIR/$OUT_DIR"

echo "Output directory: $REAL_OUT_DIR"

# Check if the output directory exists
if [ ! -d "$REAL_OUT_DIR" ]; then
  mkdir "$REAL_OUT_DIR"
fi

read_script(){
    # Check if the file is readable
    if [ -r "$1" ]; then
        echo "Running $1"
        grep -v '^#' "$1" >> "$REAL_OUT_DIR/$OUT_FILE_NAME"
    else
        echo "Error: Cannot read $1"
        exit 1
    fi
}

# Add #!/usr/bin/env bash to the build file
echo "#!/usr/bin/env bash" > "$REAL_OUT_DIR/$OUT_FILE_NAME"

# Read the scripts config file provided and copy the scripts into one file in output
for SCRIPT_DIR in "${SCRIPT_DIRECTORIES[@]}"
do
  for script in "$RUN_DIR/$SCRIPT_DIR"/*.sh; do
    read_script "$script"
  done
done

echo "Merged $RUN_DIR to $REAL_OUT_DIR/$OUT_FILE_NAME"