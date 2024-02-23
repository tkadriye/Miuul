from snakemake.io import directory

rule all:
    input:
        #"output/tRNA_scan_result.txt",
        #"output/G_intestinalis.tRNA",
        #expand("output/tRNAscan/{sp}.tRNA", sp=["G_muris", "G_intestinalis"]),
        #expand("output/blastn/G_intestinalis/{sp}.blastn",sp=["G_muris", "S_salmonicida"]),
        #expand("output/orthofinder/{genome}.fasta", genome=["G_muris_aa", "G_intestinalis_aa", "S_salmonicida_aa"]),
        "output/1_orthofinder/"


rule makeblastdb:
    input:
        "resource/{type}/db/{db}.fasta"
    output:
        "output/{type}/db/{db}.ndb",
        "output/{type}/db/{db}.nhr",
        "output/{type}/db/{db}.nin",
        "output/{type}/db/{db}.not",
        "output/{type}/db/{db}.nsq",
        "output/{type}/db/{db}.ntf",
        "output/{type}/db/{db}.nto"
    params:
        outname="output/{type}/db/{db}"
    shell:
        'makeblastdb -dbtype nucl -in {input} -out {params.outname}'
rule blastn:
    input:
        query="resources/{type}/query/{query}.fasta",
        db="output/{type}/db/{db}.ndb"
    output:
        "output/{type}/{db}/{query}.blastn"
    params:
        perc_identity=95,
        outfnt=6,
        num_threads=2,
        max_target_seqs=1,
        max_hsps=1,
        db_prefix="output/{type}/db/{db}"
    script:
        "script/blastn.py"

rule orthofinder:
    input:
        fasta = "resource/orthofinder/",
    output:
          directory('output/orthofinder/')
    conda:
        "env/env.yaml"
    script:
          "scripts/2_BioinformaticsTools/orthofinder.py"


