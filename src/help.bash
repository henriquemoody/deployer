_help()
{
    sed -E 's/^#\s?(.*)/\1/g' "${0}" |
        sed -nE '/^Usage/,/^Report/p' |
        sed "s/{script}/${SCRIPT_NAME}/g"
}
