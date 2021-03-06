#!/bin/bash
# Author: Leo Gutierrez | @leogtzr

show_help() {
cat <<HELP_TEXT

    ${0} [--stlen <stacktrace_length> --count <LWP_COUNT] | [--help|-h]

HELP_TEXT
}

readonly opts=$(getopt -o s:,c:,h --long stlen:,count:,help -- "${@}" 2> /dev/null)

eval set -- "${opts}"
stlen_flag=0
count_flag=0

while true; do
    case "${1}" in

        --stlen|-s)
            stlen_flag=1
            readonly stacktrace_length="${2}"
            shift
            shift
            ;;

        --count|-c)
            date_flag=1
            readonly max_number_lwp="${2}"
            shift
            shift
            ;;

        --help|-h)
            show_help
            exit 0
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
    esac
done

for jvm_info in $(jps -l | awk '{print $1 "," $2}'); do
    jvmpid=$(awk -F ',' '{print $1}' <<< "${jvm_info}")
    instance=$(awk -F ',' '{print $2}' <<< "${jvm_info}")
    printf "Analyzing ===> {%s}, pid: %d\n" "${instance}" "${jvmpid}"
    if [[ ! -z "${jvmpid}" ]]; then
        printf "Top %d lwps for %s - %d\n" "${max_number_lwp:-15}" "${instance}" "${jvmpid}"
        ps -eLo pcpu,pid,lwp,nlwp,ruser,pcpu,stime,etime,thcount | grep --fixed-strings "${jvmpid}" | \
            sort --key 1 --reverse | head --lines ${max_number_lwp:-15} > "lwps.${instance}"
        if [[ -f "lwps.${instance}" ]]; then
            cat "lwps.${instance}"
            jstack -l "${jvmpid}" > "${instance}.${jvmpid}.tdump"
            while read lwp; do
                pid_in_hex=$(printf "%x" "${lwp}")
                printf "lwp: %s -> 0x%s\n" "${lwp}" "${pid_in_hex}"
                LC_ALL=C grep --extended-regexp --after-context "${stacktrace_length:-30}" " nid.*0x${pid_in_hex}" \
                    "${instance}.${jvmpid}.tdump" --color=always
            done < <(awk '{print $3}' "lwps.${instance}")
        fi

    fi
done

exit 0
