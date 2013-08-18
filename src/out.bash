_out()
{
    local params
    local message

    params="-e"
    while [[ ${1} = -* ]]; do
        params="${params} ${1}"
        shift
    done

    message="${@}<0>"

    if [ ${SCRIPT_INTERACTIVE} -eq 1 ]; then
        message=$(echo "${message}" | sed -E $'s/<([0-9;]+)>/\033\[\\1m/g')
    else
        message=$(echo "${message}" | sed -E 's/<[0-9;]+>//g')
    fi
    echo ${params} "${message}"
}
