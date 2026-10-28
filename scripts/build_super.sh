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

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

add() { # name image
    local img=$2 size
    # lpmake needs raw images; the build emits sparse ones
    if [ "$(head -c4 "$img" | od -An -tx4 | tr -d ' ')" = "ed26ff3a" ]; then
        simg2img "$img" "$TMP/$1.img"; img=$TMP/$1.img
    fi
    size=$(stat -c%s "$img")
    args+=(--partition "$1_a:readonly:$size:qti_dynamic_partitions_a" --image "$1_a=$img"
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
