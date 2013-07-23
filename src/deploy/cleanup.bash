_deploy_cleanup()
{
    local server_name="${1}"
    local server_address="${2}"

    ssh -q "root@${server_address}" <<EOF
rm -rf "${APPLICATION_DIRECTORY}.backup"
EOF

    code=${?}

    if [[ ${code} -gt 0 ]]; then
        _echo "<31>Failure when cleaning server ${server_name} (${server_address})<0>"
    else
        _echo "<32>Success on cleaning server ${server_name} (${server_address})<0>"
    fi

    return ${code}
}