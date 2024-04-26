# bash-merger

bash-merger is a shell script utility designed to merge multiple shell scripts into a single script. This can be useful for consolidating scripts for easier distribution or deployment.

## Features

- Merges multiple shell scripts into a single script.
- Allows for custom configuration via a config file.
- Checks for the existence and readability of scripts before merging.

## Usage

1. Get latest version of the script.

<!-- Url is: https://github.com/soliyte/bash-merger/ download from releases -->
```
wget https://raw.githubusercontent.com/soliyte/bash-merger/releases/latest/merge.sh
```

or

```
curl -O https://raw.githubusercontent.com/soliyte/bash-merger/releases/latest/merge.sh
```

2. Make it executable

```
chmod +x merge.sh
```

3. Run
```shellscript
./merge.sh -r <run_directory> -c <config_file>
```

### Options

- `-r <run_directory>`: The directory containing the scripts or script directories to merge.
- `-c <config_file>`: The configuration file containing the list of scripts to merge.

## Configuration

The configuration file (`merge-config.sh` by default) allows you to specify the following:

- `OUT_DIR` : The output directory for the merged script. 
- `OUT_FILE_NAME` : The name of the merged script. 
- `SCRIPT_DIRECTORIES` : An array of directories containing the scripts to be merged.

You can find examples of configuration files in the [examples](examples) directory.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
