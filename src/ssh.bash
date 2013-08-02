_ssh()
{
    local host="${1}"
    local user="${SSH_USER}"
    local port="${SSH_PORT}"
    local private_key_file="${SSH_PRIVATE_KEY_FILE}"

    ssh \
        -q \
        $(test ! -z ${private_key_file} && echo "-i ${private_key_file}") \
        -o "ConnectTimeout=${SSH_CONNECTION_TIMEOUT}" \
        -o "PasswordAuthentication=no" \
        -o "StrictHostKeyChecking=no" \
        -o "UserKnownHostsFile=/dev/null" \
        -p "${port}" \
        "${user}@${host}" < /dev/stdin
}
