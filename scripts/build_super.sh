#!/bin/bash
# Pack a flashable super.img: LineageOS system/system_ext/product + stock HyperOS 4 partitions.
# usage: build_super.sh <lineage OUT dir> <dir with stock *_a.img from lpunpack> <output super.img>
# Layout matches stock: virtual A/B, 3 metadata slots, group qti_dynamic_partitions (18779996160).
set -euo pipefail
OUT=$1; STOCK=$2; DEST=$3
SUPER_SIZE=18790481920
GROUP_SIZE=18779996160

args=(--metadata-size 65536 --super-name super --metadata-slots 3 --virtual-ab
      --device super:$SUPER_SIZE
      --group qti_dynamic_partitions_a:$GROUP_SIZE --group qti_dynamic_partitions_b:$GROUP_SIZE)

add() { # name image
    local size; size=$(stat -c%s "$2")
    args+=(--partition "$1_a:readonly:$size:qti_dynamic_partitions_a" --image "$1_a=$2"
           --partition "$1_b:readonly:0:qti_dynamic_partitions_b")
}

add system     "$OUT/system.img"
add system_ext "$OUT/system_ext.img"
add product    "$OUT/product.img"
for p in vendor odm vendor_dlkm system_dlkm mi_ext mi_product; do
    add $p "$STOCK/${p}_a.img"
done

lpmake "${args[@]}" --sparse --output "$DEST"
echo "super: $DEST"
