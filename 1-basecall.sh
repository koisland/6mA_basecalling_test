#!/bin/bash

set -euo pipefail

mkdir -p data/pod5 data/ubam data/models
s3_uri="s3://ont-open-data/giab_2025.01/flowcells/HG002/PAW70337/pod5"
ids=(
    PAW70337_66b2eea5_de8117b1_0
    PAW70337_66b2eea5_de8117b1_1
    PAW70337_66b2eea5_de8117b1_2
)
# Used models
main_model=dna_r10.4.1_e8.2_400bps_sup@v5.2.0
modbase_models=(
    dna_r10.4.1_e8.2_400bps_sup@v5.2.0_5mCG_5hmCG@v2
    dna_r10.4.1_e8.2_400bps_sup@v5.2.0_6mA@v1
)
for model in "${main_model}" "${modbase_models[@]}"; do
    /opt/logsdon_lab/dorado-1.1.1-linux-x64/bin/dorado download \
    --model "${model}" \
    --models-directory data/models
done

modbase_models_str=$(echo "${modbase_models[@]}" | sed 's/ /\n/g' | awk '{ print "data/models/"$1}' | paste -sd,) 
for id in "${ids[@]}"; do
    aws s3 cp \
        --no-sign-request \
        ${s3_uri}/${id}.pod5 \
        data/pod5/${id}.pod5

    /opt/logsdon_lab/dorado-1.1.1-linux-x64/bin/dorado basecaller \
        "data/models/${main_model}" \
        --modified-bases-models "${modbase_models_str}" \
        data/pod5/${id}.pod5 \
        > data/ubam/${id}.bam 2> data/ubam/${id}.log
done
