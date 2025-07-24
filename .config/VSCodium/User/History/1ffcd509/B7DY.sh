#!/bin/bash

for folder in $(ls -d */)
yq '.metadata.labels."gitlab.publicplan.cloud/primary-application-project-id"' 