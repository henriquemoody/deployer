_check_access()
{
    local server_name="${1}"
    local server_address="${2}"

    ssh -o "ConnectTimeout=${SSH_CONNECTION_TIMEOUT}" \
        -q "root@${server_address}" <<EOF
echo > /dev/null
EOF

    code=${?}

    if [[ ${code} -gt 0 ]]; then
        _echo "<31>Unable to access server ${server_name} (${server_address})<0>"
    else
        _echo "<32>Able to connect to the server ${server_name} (${server_address})<0>"
    fi

    return ${code}
}