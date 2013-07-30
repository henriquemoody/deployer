_deploy_finish()
{
    local server_name="${1}"
    local server_address="${2}"

    ssh -q "root@${server_address}" <<EOF

if [[ "${VERBOSE}" = "v" ]]; then
    set -x
fi

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}"

cd "${APPLICATION_DIRECTORY}.current"

if [[ -f remote-post-default.hook ]]; then
    sh remote-post-default.hook \
        "${APPLICATION_DIRECTORY}" \
        "${APPLICATION_OWNER}" \
        "${APPLICATION_GROUP}" \
        "${ENVIRONMENT}" \
        "${server_address}"
fi

if [[ -f remote-post-env.hook ]]; then
    sh remote-post-env.hook \
        "${APPLICATION_DIRECTORY}" \
        "${APPLICATION_OWNER}" \
        "${APPLICATION_GROUP}" \
        "${ENVIRONMENT}" \
        "${server_address}"
fi

rm -f *.hook
EOF

    code=${?}

    if [[ ${code} -gt 0 ]]; then
        _echo "<31>Failure when deploying to server ${server_name} (${server_address})<0>"
    else
        _echo "<32>Success on deploying to server ${server_name} (${server_address})<0>"
    fi

    return ${code}
}