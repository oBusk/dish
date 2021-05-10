#!/bin/bash

CACHE_DIR="./.cache"

function ensure_folder_exists() {
    [[ -d "$1" ]] || mkdir "$1"
}

function ensure_file_exists() {
    [[ -e "$1" ]] || touch "$1"
}

function ensure_cache_file_exists() {
    ensure_folder_exists $CACHE_DIR
    ensure_file_exists $1
}
