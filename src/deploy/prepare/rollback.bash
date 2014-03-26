_deploy_prepare_rollback()
{
    local server_address="${1}"

    _ssh "${server_address}" <<EOF
set -e
set -x

test ! -d "${APPLICATION_DIRECTORY}.oldest" &&
    echo "Unable to find ${APPLICATION_DIRECTORY}.oldest"

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    ln -sfn "${APPLICATION_DIRECTORY}.backup" "${APPLICATION_DIRECTORY}"

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    mv "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.newest"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" \
    mv "${APPLICATION_DIRECTORY}.oldest" "${APPLICATION_DIRECTORY}.current"
EOF
}
