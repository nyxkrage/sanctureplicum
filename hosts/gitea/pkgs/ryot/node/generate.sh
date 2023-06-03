#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash node2nix curl nodePackages.npm
set -euxo pipefail
IFS=$'\n\t'
if [ -n "${DEBUG:-}" ]; then set -x; fi


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VERSION=$(grep -Po 'version = "\K.+?(?=")' "$SCRIPT_DIR/../default.nix")
RAW_URL="https://raw.githubusercontent.com/IgnisDa/ryot/${VERSION}"
declare -A PACKAGES
PACKAGES=( ["package.json"]="ryot-package.json" ["apps/frontend/package.json"]="frontend-package.json" ["libs/generated/package.json"]="generated-package.json" ["libs/graphql/package.json"]="graphql-package.json")

for PACKAGE in ${!PACKAGES[@]}; do
    echo ${PACKAGES[@]}
    curl -sSLf "$RAW_URL/$PACKAGE" -o "$SCRIPT_DIR/${PACKAGES[$PACKAGE]}"
done

DEPENDENCIES=$(jq -crs '[.[] | .dependencies, .devDependencies | select(. != null)] | add | map_values(select(. != "workspace:*"))' ${PACKAGES[@]/#/"$SCRIPT_DIR/"})
TMP=$(mktemp)
jq ".dependencies = $DEPENDENCIES" "$SCRIPT_DIR/package.json" > "$TMP" && mv "$TMP" "$SCRIPT_DIR/package.json"

npm --prefix "$SCRIPT_DIR" i  --lockfile-version 2 --package-lock-only

node2nix -d -i "$SCRIPT_DIR/package.json" -l "$SCRIPT_DIR/package-lock.json" -o "$SCRIPT_DIR/node-packages.nix" -c "$SCRIPT_DIR/default.nix" -e "$SCRIPT_DIR/node-env.nix"
