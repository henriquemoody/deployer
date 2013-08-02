_deploy_cleanup()
{
    local server_name="${1}"
    local server_address="${2}"
    local server_log_filename="${DEPLOY_LOG_BASE}-${server_name}.log"

    _ssh "${server_address}" >> "${server_log_filename}" 2>&1 <<EOF
rm -rf "${APPLICATION_DIRECTORY}.backup"
EOF

    code=${?}

    if [[ ${code} -gt 0 ]]; then
        _echo "<31>Failure when cleaning server ${server_name} (${server_address})<0>" 1>&2
    else
        _echo "<32>Success on cleaning server ${server_name} (${server_address})<0>"
    fi

    return ${code}
}