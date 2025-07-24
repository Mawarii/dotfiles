#!/bin/bash

for folder in $(ls -d */)
    cat $folder/application.yaml | yq '.metadata.labels."gitlab.publicplan.cloud/primary-application-project-id"'
done
