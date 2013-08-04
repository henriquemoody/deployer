_conf_read()
{
    local filename="${1}";
    local name="${2}"
    local content=""

    if [[ ! -f "${filename}" ]]; then
        return 1;
    fi

    content=$(grep "^${name}" "${filename}")
    if [[ -z "${content}" ]]; then
        return 2
    fi

    echo "${content}" |
        egrep -q "^[A-Za-z]+ .+" &&
            echo "${content}" |
                cut -d ' ' -f 2- |
                sed -E 's/ +$//g'
}
