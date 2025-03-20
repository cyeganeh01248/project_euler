default:
    just --list

run-lua:
    #!/bin/bash
    cd lua
    just

start-offline-server:
    #!/bin/bash
    cd offline_archive
    just
