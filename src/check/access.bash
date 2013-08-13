_check_access()
{
    local server_name="${1}"
    local server_address="${2}"

    _ssh "${server_address}" > /dev/null 2>&1 <<EOF
echo > /dev/null
EOF

    code=${?}

    if [[ ${code} -gt 0 ]]; then
        _echo "<31>Unable to access server ${server_name} (${server_address})<0>" 1>&2
    else
        _echo "<32>Able to connect to the server ${server_name} (${server_address})<0>"
    fi

    return ${code}
}
