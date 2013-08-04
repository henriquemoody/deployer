_deploy_prepare_upgrade()
{
    local server_address="${1}"
    local server_log_filename="${2}"

    _ssh "${server_address}" >> "${server_log_filename}" 2>&1 <<EOF

if [[ "${VERBOSE}" = "v" ]]; then
    set -x
fi

if [[ ! -d "${APPLICATION_DIRECTORY}" ]]; then
    sudo mkdir -p${VERBOSE} "$(dirname "${APPLICATION_DIRECTORY}")" &&
        sudo chown -R${VERBOSE} "${APPLICATION_OWNER}:${APPLICATION_GROUP}" "$(dirname "${APPLICATION_DIRECTORY}")"

    test ${?} -gt 0 &&
        echo "Failure creating base directory" &&
        exit 1
fi

if [[ ! -d "${APPLICATION_DIRECTORY}.current" ]]; then
    sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
        mkdir -p${VERBOSE} "${APPLICATION_DIRECTORY}.current"
    sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
        ln -sfn "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}"
    sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
        rsync \
            -arzO${VERBOSE} \
            -e 'ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' \
            "${LOCAL_ADDRESS}:${ENVIRONMENT_CURRENT}/" \
            "${APPLICATION_DIRECTORY}.current"
fi

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.newest" &&
    sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
        rsync \
            -arzO${VERBOSE} \
            --delete \
            -e 'ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' \
            "${LOCAL_ADDRESS}:${ENVIRONMENT_CURRENT}/" \
            "${APPLICATION_DIRECTORY}.newest"

test ${?} -gt 0 &&
    echo "Failure when copying new code" &&
    exit 1

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    ln -sfn "${APPLICATION_DIRECTORY}.backup" "${APPLICATION_DIRECTORY}"

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    rm -rf "${APPLICATION_DIRECTORY}.oldest"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    mv "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.oldest"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
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
}
