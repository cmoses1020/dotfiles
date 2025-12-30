#!/bin/bash
STATEURLS=(
    "az.tmutest.com"
    "azcg.tmutest.com"
    "ar.tmutest.com"
    "ca.tmutest.com"
    "id.tmutest.com"
    "idfa.tmutest.com"
    "ia.tmutest.com"
    "ia-dcp.tmutest.com"
    "ir.tmutest.com"
    "ky.tmutest.com"
    "mccn.tmutest.com"
    "mcht.tmutest.com"
    "mcsp.tmutest.com"
    "mc.tmutest.com"
    "ma.tmutest.com"
    "mi.tmutest.com"
    "mn.tmutest.com"
    "mr.tmutest.com"
    "ms.tmutest.com"
    "mo.tmutest.com"
    "mt.tmutest.com"
    "mtcma.tmutest.com"
    "nm.tmutest.com"
    "nd.tmutest.com"
    "oh.tmutest.com"
    "om.tmutest.com"
    "ox.tmutest.com"
    "ok.tmutest.com"
    "or.tmutest.com"
    "re.tmutest.com"
    "sd.tmutest.com"
    "tn.tmutest.com"
    "ut.tmutest.com"
    "wi.tmutest.com"
    "wy.tmutest.com"
    "nm.tmutest.com"
)


for SITE in ${STATEURLS[@]}; do
    COMMAND="mysql -V"

    echo -e "\n\e[90m==================== \e[34mSTART: $SITE \e[90m====================\e[0m"
    ssh forge@$SITE $COMMAND
    echo -e "\e[90m==================== \e[32mEND: $SITE \e[90m======================\e[0m\n"
done
