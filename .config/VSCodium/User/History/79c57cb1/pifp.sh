#!/bin/bash

for folder in $(ls -d */); do
    sed -i -E 's/(gitlab\.publicplan\.cloud\/primary-application-project-id: )([0-9]+)/\1"\2"/' "$folder/application.yaml"
done