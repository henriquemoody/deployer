_deploy_prepare()
{
    local server_name="${1}"
    local server_address="${2}"

    if [[ "${DEPLOY_TYPE}" == "upgrade" ]]; then
        ssh "root@${server_address}" <<EOF
test ! -d "${APPLICATION_DIRECTORY}.current" &&
    rsync -arzO${VERBOSE} -e 'ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' "${LOCAL_ADDRESS}:${ENVIRONMENT_CURRENT}/" "${APPLICATION_DIRECTORY}.current"

if [[ "${VERBOSE}" = "v" ]]; then
    set -x
fi

cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.newest" &&
    rsync -arzO${VERBOSE} --delete -e 'ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' "${LOCAL_ADDRESS}:${ENVIRONMENT_CURRENT}/" "${APPLICATION_DIRECTORY}.newest"

test ${?} -gt 0 &&
    echo  "Failure when copying new code" &&
    exit 1

chown -R "${APPLICATION_OWNER}:${APPLICATION_GROUP}" "${APPLICATION_DIRECTORY}.newest"

test -d "${APPLICATION_DIRECTORY}.newest/bo/public/file" &&
    mv "${APPLICATION_DIRECTORY}.newest/bo/public/file" "${APPLICATION_DIRECTORY}.newest/bo/public/file.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn /mnt/nfs/telex_public/bo/public/file "${APPLICATION_DIRECTORY}.newest/bo/public/file"

test -d "${APPLICATION_DIRECTORY}.newest/sig/public/file" &&
    mv "${APPLICATION_DIRECTORY}.newest/sig/public/file" "${APPLICATION_DIRECTORY}.newest/sig/public/file.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn /mnt/nfs/telex_public/sig/public/file "${APPLICATION_DIRECTORY}.newest/sig/public/file"

test -d "${APPLICATION_DIRECTORY}.newest/sig/public/pagamentos" &&
    mv "${APPLICATION_DIRECTORY}.newest/sig/public/pagamentos" "${APPLICATION_DIRECTORY}.newest/sig/public/pagamentos.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn /mnt/nfs/telex_public/sig/public/pagamentos "${APPLICATION_DIRECTORY}.newest/sig/public/pagamentos"

sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" cp -r "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.backup"
sudo -u "${APPLICATION_OWNER}" -g "${APPLICATION_GROUP}" ln -sfn "${APPLICATION_DIRECTORY}.backup" "${APPLICATION_DIRECTORY}"

rm -rf "${APPLICATION_DIRECTORY}.oldest"
mv "${APPLICATION_DIRECTORY}.current" "${APPLICATION_DIRECTORY}.oldest"
mv "${APPLICATION_DIRECTORY}.newest" "${APPLICATION_DIRECTORY}.current"

cd "${APPLICATION_DIRECTORY}.current"
test -f default-deploy-pre.hook && sh default-deploy-pre.hook
test -f env-deploy-pre.hook && sh env-deploy-pre.hook

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