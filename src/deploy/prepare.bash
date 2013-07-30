_deploy_prepare()
{
    local server_name="${1}"
    local server_address="${2}"

    if [[ "${DEPLOY_TYPE}" == "upgrade" ]]; then
        ssh "root@${server_address}" <<EOF

if [[ "${VERBOSE}" = "v" ]]; then
    set -x
fi

mkdir -p${VERBOSE} "$(dirname "${APPLICATION_DIRECTORY}")"
chown "${APPLICATION_OWNER}:${APPLICATION_GROUP}" "$(dirname "${APPLICATION_DIRECTORY}")"

if [[ ! -d "${APPLICATION_DIRECTORY}.current" ]]; then
    sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" mkdir -p${VERBOSE} "${APPLICATION_DIRECTORY}.current"
    sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}"
    rsync -arzO${VERBOSE} -e 'ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' "${LOCAL_ADDRESS}:${ENVIRONMENT_CURRENT}/" "${APPLICATION_DIRECTORY}.current"
fi

cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.newest" &&
    rsync -arzO${VERBOSE} --delete -e 'ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' "${LOCAL_ADDRESS}:${ENVIRONMENT_CURRENT}/" "${APPLICATION_DIRECTORY}.newest"

test ${?} -gt 0 &&
    echo  "Failure when copying new code" &&
    exit 1

chown -R "${APPLICATION_OWNER}:${APPLICATION_GROUP}" "${APPLICATION_DIRECTORY}.newest"

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn "${APPLICATION_DIRECTORY}.backup" "${APPLICATION_DIRECTORY}"

rm -rf "${APPLICATION_DIRECTORY}.oldest"
mv "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.oldest"
mv "${APPLICATION_DIRECTORY}.newest" "${APPLICATION_DIRECTORY}.current"

cd "${APPLICATION_DIRECTORY}.current"

if [[ -f remote-pre-default.hook ]]; then
    sh remote-pre-default.hook \
        "${APPLICATION_DIRECTORY}" \
        "${APPLICATION_OWNER}" \
        "${APPLICATION_GROUP}" \
        "${ENVIRONMENT}" \
        "${server_address}"
fi

if [[ -f remote-pre-env.hook ]]; then
    sh remote-pre-env.hook \
        "${APPLICATION_DIRECTORY}" \
        "${APPLICATION_OWNER}" \
        "${APPLICATION_GROUP}" \
        "${ENVIRONMENT}" \
        "${server_address}"
fi

EOF
    else
        ssh "root@${server_address}" <<EOF
test ! -d "${APPLICATION_DIRECTORY}.oldest" &&
    echo "Unable to find ${APPLICATION_DIRECTORY}.oldest" &&
    exit 1

if [[ "${VERBOSE}" = "v" ]]; then
    set -x
fi

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn "${APPLICATION_DIRECTORY}.backup" "${APPLICATION_DIRECTORY}"

mv "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.newest"
mv "${APPLICATION_DIRECTORY}.oldest" "${APPLICATION_DIRECTORY}.current"
EOF
    fi

    code=${?}

    if [[ ${code} -gt 0 ]]; then
        _echo "<31>Failure when syncing server ${server_name} (${server_address})<0>"
    else
        _echo "<32>Success on syncing server ${server_name} (${server_address})<0>"
    fi

    return ${code}
}