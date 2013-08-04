_ssh()
{
    local host="${1}"
    local user="${SSH_USER}"
    local options="${SSH_OPTIONS}"

    ssh \
        -q \
        ${options} \
        ${user}@${host} < /dev/stdin
}
