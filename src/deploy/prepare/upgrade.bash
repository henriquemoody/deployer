_deploy_prepare_upgrade()
{
    local server_address="${1}"
    local options="${SSH_OPTIONS}"

    _ssh "${server_address}" <<EOF
set -e
set -x

if [[ ! -d "${APPLICATION_DIRECTORY}" ]]; then
    sudo mkdir -p${VERBOSE} "$(dirname "${APPLICATION_DIRECTORY}")"
fi

sudo chown "${APPLICATION_OWNER}:${APPLICATION_GROUP}" "$(dirname "${APPLICATION_DIRECTORY}")"

if [[ ! -d "${APPLICATION_DIRECTORY}.current" ]]; then
    sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
        mkdir -p${VERBOSE} "${APPLICATION_DIRECTORY}.current"
fi

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.newest"
EOF

   test ${?} -gt 0 &&
        exit 1

    rsync \
        -arzO${VERBOSE} \
        --delete \
        "${ENVIRONMENT_CURRENT}/"* \
        -e "ssh ${SSH_OPTIONS}" \
        --rsync-path="sudo rsync" "${SSH_USER}@${server_address}:${APPLICATION_DIRECTORY}.newest/"

    test ${?} -gt 0 &&
        exit 2

    _ssh "${server_address}" <<EOF
set -e
set -x

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
