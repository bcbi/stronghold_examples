CTAKES_HOME=/opt/apache-ctakes-4.0.0

OUTDIR="$HOME/stronghold_examples/ctakes/clinical_notes_output"

if [ ! -d "$OUTDIR" ]; then
  mkdir $OUTDIR
fi

${CTAKES_HOME}/bin/runClinicalPipeline.sh  -i $HOME/stronghold_examples/ctakes/clinical_notes_input --xmiOut $OUTDIR -l org/apache/ctakes/dictionary/lookup/fast/sno_rx_18ab_sh.xml
