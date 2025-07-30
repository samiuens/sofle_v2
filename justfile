# Copy only the keymap to the keyboard configuration
keymap:
    #!/bin/bash
    cp samiuens.json splitkb-sofle_v2/keymaps/samiuens/keymap.json

# Convert the 'keymap.json' into a 'keymap.c' file
convert:
    #!/bin/bash
    cp samiuens.json splitkb-sofle_v2/keymaps/samiuens/keymap.json
    qmk json2c splitkb-sofle_v2/keymaps/samiuens/keymap.json -o splitkb-sofle_v2/keymaps/samiuens/keymap.c
    rm -r splitkb-sofle_v2/keymaps/samiuens/keymap.json

# Copy keyboard configuration to your configured qmk overlay dir
copy:
    #!/bin/bash
    just keymap
    overlay_dir=$(qmk config user.overlay_dir | sed 's/^user.overlay_dir=//')
    rm -rf $overlay_dir/keyboards/splitkb/aurora/sofle_v2
    cp -R ./splitkb-sofle_v2 $overlay_dir/keyboards/splitkb/aurora/sofle_v2

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
    qmk compile -kb splitkb/aurora/sofle_v2 -km samiuens
    cp $overlay_dir/splitkb_aurora_sofle_v2_rev1_samiuens.uf2 ./build

# Flash keyboard firmware
flash:
    #!/bin/bash
    # Copy keyboard configuration
    just copy
    # Flash firmware via qmk (compile is included)
    qmk flash -kb splitkb/aurora/sofle_v2 -km samiuens

# Show available commands
help:
    just --list