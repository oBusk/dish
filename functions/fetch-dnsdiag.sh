#!/bin/bash

function fetch_dnsdiag() {
    mkdir .dnsdiag
    curl -s https://api.github.com/repos/farrokhi/dnsdiag/releases/latest |
        grep "browser_download_url.*linux-x86_64-bin" |
        cut -d : -f 2,3 |
        tr -d \" |
        wget -i - -O - |
        tar -xz -C .dnsdiag --strip-components=1
}
