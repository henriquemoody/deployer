_tool_clearname()
{
    local name="${1}"
    if [[ -z "${name}" ]]; then
        name=$(cat /dev/stdin)
    fi

    echo "${name}" | sed -E 's/[^a-zA-Z._-]+/./g'
}
