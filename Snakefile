from snakemake.utils import compress

rule all:
    input: expand('output/blastn/V_anguillarum/{sample}.done', sample=['P_damselae', 'V_cholera'])

@compress
    def blastn(wildcards):
        query = f"resources/blastn/query/{wildcards.sample}.fasta"
        database = "P_damselae.fasta"
        output = f'output/blastn/V_anguillarum/{wildcards.sample}.blastn'
    shell = """
        {query} {database} | samtools view -F 984 -q 50 -o - > {output} && bgzip {output} && tabix {output}.gz
    """
rule blastn_multiple:
    input:
        query="{query}",
        database="P_damselae.fasta"
    output:
        expand('output/blastn/V_anguillarum/{sample}.blastn', sample=["P_damselae", "V_cholera"])
    shell:
        '{input.query} {input.database} | samtools view -F 984 -q 50 -o - > {output} && bgzip {output} && tabix {output}.gz'

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



