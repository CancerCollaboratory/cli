#!/bin/bash

function argument_error() {
    echo "Usage:  upload.sh [path to uuid-folder]"
    exit 1
}

function environment_variable_error() {
    echo "The following environment variables need to be defined:"
    echo "ACCESSTOKEN"
    exit 1
}

function metadata_error() {
    echo "Registration with the metadata service failed."
    exit 1
}

function download_error() {
    echo "Upload of data to S3 failed."
    exit 1
}

# Check Arguments and Environment Variables
[[ -z ${1} ]] && argument_error
[[ -z ${ACCESSTOKEN} ]] && environment_variable_error

# Register with metadata service
bash /collab/metadata/bin/dcc-metadata-client -i "${1}" -m manifest.txt -o /collab
[[ ! -f /collab/manifest.txt ]] && metadata_error

# Upload the datafiles
bash /collab/storage/bin/col-repo upload --manifest /collab/manifest.txt
[[ $? -ne 0 ]] && download_error

# Cleanup the manifest
[[ -f /collab/manifest.txt ]] && mv /collab/manifest.txt /collab/upload/completed_manifest.txt

# Consolidate log files
[[ ! -d /collab/upload/logs ]] && mkdir /collab/upload/logs
cp /collab/metadata/logs/* /collab/upload/logs
cp /collab/storage/logs/* /collab/upload/logs
