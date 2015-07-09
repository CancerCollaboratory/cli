#!/bin/bash

function argument_error() {
    echo "Usage:  upload.sh [path to uuid-folder]"
    exit 1
}

function environment_variable_error() {
    echo "The following environment variables need to be defined:"
    echo "ACCESS_TOKEN"
    exit 1
}

function metadata_error() {
    echo "Registration with the metadata service failed."
    exit 1
}

# Check Arguments and Environment Variables
[[ -z ${1} ]] && argument_error
[[ -z ${ACCESS_TOKEN} ]] && environment_variable_error

# Register with metadata service
bash /collab/storage/bin/dcc-metadata-client -i "${1}" -m manifest.txt -o /collab
[[ ! -f /manifest.txt ]] && metadata_error

# Upload the datafiles
bash /collab/storage/bin/col-repo --manifest /collab/manifest.txt
