# 6mA Basecalling test

## Setup
Ensure dorado `v1.1.1` in path. 
```bash
alias dorado="/opt/logsdon_lab/dorado-1.1.1-linux-x64/bin/dorado"
dorado --version
```

Create environment for the rest.
```bash
conda env create -f env.yaml --name basecall
```

## Data
See:
* https://epi2me.nanoporetech.com/dataindex/

```bash
aws s3 ls --no-sign-request s3://ont-open-data/giab_2025.01/flowcells/HG002/PAW70337/pod5/
```

Chose first 3 pod5s to test.
```
PAW70337_66b2eea5_de8117b1_0
PAW70337_66b2eea5_de8117b1_1
PAW70337_66b2eea5_de8117b1_2
```

## 1-basecall
Downloads the correct models + pod5 files and basecalls them.
```bash
bash 1-basecall.sh
```

## 2-align
Downloads HG002 v1.1 and align reads to reference assembly with minimap2.
```bash
bash 2-align.sh
```
