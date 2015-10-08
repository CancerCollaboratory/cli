#!/bin/bash

exit_code=0

function argument_error() {
    echo "Usage:  upload-ceph.sh [path to uuid-folder]"
    exit 1
}

function environment_variable_error() {
    echo "The following environment variables need to be defined:"
    echo "ACCESSTOKEN"
    exit 1
}

function metadata_error() {
    echo "Registration with the metadata service failed."
    exit_code=1
}

function download_error() {
    echo "Upload of data to Ceph failed."
    exit_code=1
}

# Check Arguments and Environment Variables
[[ -z ${1} ]] && argument_error
[[ -z ${ACCESSTOKEN} ]] && environment_variable_error

# Register with metadata service
bash /collab/metadata/bin/dcc-metadata-client -i "${1}" -m manifest.txt -o /collab
[[ $? -ne 0 ]] && metadata_error

# Upload the datafiles
bash /collab/storage-ceph/bin/dcc-storage-client upload --manifest /collab/manifest.txt
[[ $? -ne 0 ]] && download_error

# Cleanup the manifest
[[ -f /collab/manifest.txt ]] && mv /collab/manifest.txt /collab/upload/completed_manifest.txt

# Consolidate log files
[[ ! -d /collab/upload/logs ]] && mkdir /collab/upload/logs
cp /collab/metadata/logs/* /collab/upload/logs
cp /collab/storage-ceph/logs/* /collab/upload/logs

# Final Exit Code
exit $exit_code

