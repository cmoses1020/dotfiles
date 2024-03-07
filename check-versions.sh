#!/bin/bash
COMMAND="apt policy php8.2-dev"

STATEURLS=(
    "az.tmutest.com"
    "ar.tmuniverse.com"
    "ca.tmutest.com"
    "id.tmutest.com"
    "ky.tmutest.com"
    "mc.tmutest.com"
    "ma.tmuniverse.com"
    "mi.tmutest.com"
    "mn.tmutest.com"
    "mr.tmutest.com"
    "ms.tmutest.com"
    "mo.tmutest.com"
    "oh.tmuniverse.com"
    "om.tmutest.com"
    "ox.tmutest.com"
    "re.tmutest.com"
    "tn.tmutest.com"
    "ut.tmuniverse.com"
    "wy.tmutest.com"
    "wi.tmuniverse.com"
    "or.tmuniverse.com"
)


for SITE in ${STATEURLS[@]}; do
    VERSION=$(ssh forge@$SITE $COMMAND)
    echo -e "\e[34m$SITE \e[39mhas Version \e[93m$VERSION"
done
