#!/bin/bash
# Author: Leo Gutierrez | @leogtzr
readonly MAX_NUMBER_LWP=15
readonly STACKTRACE_LENGTH=50

for jvm_info in $(jps -l | awk '{print $1 "," $2}'); do
    jvmpid=$(awk -F ',' '{print $1}' <<< "${jvm_info}")
    instance=$(awk -F ',' '{print $2}' <<< "${jvm_info}")
    printf "Analyzing ===> {%s}, pid: %d\n" "${instance}" "${jvmpid}"
    if [[ ! -z "${jvmpid}" ]]; then
        printf "Top %d lwps for %s - %d\n" "${MAX_NUMBER_LWP}" "${instance}" "${jvmpid}"
        ps -eLo pcpu,pid,lwp,nlwp,ruser,pcpu,stime,etime,thcount | grep --fixed-strings "${jvmpid}" | \
            sort --key 1 --reverse | head --lines ${MAX_NUMBER_LWP} > "lwps.${instance}"
        if [[ -f "lwps.${instance}" ]]; then
            cat "lwps.${instance}"
            jstack -l "${jvmpid}" > "${instance}.${jvmpid}.tdump"
            while read lwp; do
                pid_in_hex=$(printf "%x" "${lwp}")
                printf "lwp: %s -> 0x%s\n" "${lwp}" "${pid_in_hex}"
                LC_ALL=C grep --extended-regexp --after-context "${STACKTRACE_LENGTH}" " nid.*0x${pid_in_hex}" \
                    "${instance}.${jvmpid}.tdump" --color=always
            done < <(awk '{print $3}' "lwps.${instance}")
        fi

    fi
done

exit 0
