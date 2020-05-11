
module load R/3.6.0
module load pandoc/2.5 # knitr
module load hdf5/1.8.21

for pref in MV-DMSO  MV-DOK; do
mkdir -p /restricted/projectnb/crem-bioinfo/project_workspace/20_01_14_marally/calculations/analysis/$pref
Rscript -e "require('rmarkdown'); render( \
input='/restricted/projectnb/crem-bioinfo/project_code/20_01_14_marally/10x.Rmd',\
output_file='/restricted/projectnb/crem-bioinfo/project_workspace/20_01_14_marally/calculations/analysis/$pref/$pref.html',\
params= list( prefix= '$pref', resDEG= 'SCT_snn_res.0.2', percent.mito= 25, regress.batch='FALSE', sc.transform ='TRUE' ))"  &
sleep 20
done 


# merge
pref="merge.sctransform"
mkdir -p /restricted/projectnb/crem-bioinfo/project_workspace/20_01_14_marally/calculations/analysis/$pref
Rscript -e "require('rmarkdown'); render(input='/restricted/projectnb/crem-bioinfo/project_code/20_01_14_marally/10x.merge.sctransform.Rmd',\
output_file='/restricted/projectnb/crem-bioinfo/project_workspace/20_01_14_marally/calculations/analysis/$pref/$pref.html',\
params= list( prefix= '$pref', resDEG= 'SCT_snn_res.0.25', percent.mito= 25, regress.batch='FALSE', sc.transform ='TRUE'))" &
sleep 20
