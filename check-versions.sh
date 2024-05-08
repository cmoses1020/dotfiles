#!/bin/bash
STATEURLS=(
    "id.tmutest.com"

    "tn.tmutest.com"
    "az.tmutest.com"
    "ca.tmutest.com"
    "ky.tmutest.com"
    "mc.tmutest.com"

    "mi.tmutest.com"
    "mn.tmutest.com"
    "mr.tmutest.com"
    "mo.tmutest.com"

    "re.tmutest.com"

    "wy.tmutest.com"
    "om.tmutest.com"
    "ox.tmutest.com"
    "azcg.tmutest.com"
    "mt.tmutest.com"
    "mtcma.tmutest.com"
    "ar.tmutest.com"
    "or.tmutest.com"
    "ma.tmutest.com"
    "wi.tmutest.com"
    "oh.tmutest.com"
    "ut.tmutest.com"
    "sd.tmutest.com"
    "nd.tmutest.com"
    "idfa.tmutest.com"
)


for SITE in ${STATEURLS[@]}; do
    COMMAND="php /home/forge/$SITE/current/artisan core:max-seats-cleanup"

    OUTPUT=$(ssh forge@$SITE $COMMAND)
    echo -e "\e[34m$SITE \e[39m \e[93m$OUTPUT"
done
