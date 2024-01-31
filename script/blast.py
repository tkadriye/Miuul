import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

blast_G_muris = pd.read_csv('/Users/Mukadder/PycharmProjects/Miuul/output/blastn/G_muris.blastn',
                            sep='\t', header=None)
blast_S_salmonicida = pd.read_csv('/Users/Mukadder/PycharmProjects/Miuul/output/blastn/S_salmonicida.blastn',
                                  sep='\t', header=None)

blast_G_muris.columns = ['qseqid', 'sseqid', 'pident', 'length', 'mismatch', 'gapopen', 'qstart', 'qend', 'sstart',
                         'send', 'evalue', 'bitscore']
blast_S_salmonicida.columns = ['qseqid', 'sseqid', 'pident', 'length', 'mismatch', 'gapopen', 'qstart', 'qend',
                               'sstart', 'send', 'evalue', 'bitscore']

# Scatter plot using bitscore and pident
plt.figure(figsize=(10, 8))
sns.scatterplot(x='bitscore', y='pident', data=blast_G_muris, hue='pident', palette='viridis')
sns.scatterplot(x='bitscore', y='pident', data=blast_S_salmonicida, hue='pident', palette='viridis')

# Set plot title and labels
plt.title('Scatter plot of BLASTn hits')
plt.xlabel('Bitscore')
plt.ylabel('Percent Identity')

# Display the plot
plt.show()