_tool_clearname()
{
    local name="${1}"
    if [[ -z "${name}" ]]; then
        name=$(cat /dev/stdin)
    fi

    echo "${name}" | sed -E 's/[^a-zA-Z0-9._-]+/./g'
}
