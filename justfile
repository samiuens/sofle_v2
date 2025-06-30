# Copy keyboard configuration to your configured qmk overlay dir
copy:
    #!/bin/bash
    overlay_dir=$(qmk config user.overlay_dir | sed 's/^user.overlay_dir=//')
    rm -rf $overlay_dir/keyboards/sofle_pico
    cp -R ./sofle_pico $overlay_dir/keyboards/sofle_pico/

# Compile keyboard firmware
compile:
    #!/bin/bash
    overlay_dir=$(qmk config user.overlay_dir | sed 's/^user.overlay_dir=//')
    
    # Copy keyboard configuration
    just copy
    # Remove build folder
    rm -rf build/
    mkdir build/
    # Compile firmware and copy it to build folder
    qmk compile -kb sofle_pico -km samiuens
    cp $overlay_dir/sofle_pico_samiuens.uf2 ./build

# Flash keyboard firmware
flash:
    #!/bin/bash
    # Copy keyboard configuration
    just copy
    # Flash firmware via qmk (compile is included)
    qmk flash -kb sofle_pico -km samiuens

# Show available commands
help:
    just --list