dt=$(date +"%Y-%m-%d")
T=$(date +%s)

# note: metamap requires full path to input/output files
INPUT=/data/git/stronghold_examples/metamap/data/multi_input_files
OUTPUT=/data/git/stronghold_examples/metamap/data/output
LOGFILES=/data/git/stronghold_examples/metamap/logs

echo $INPUT >> $LOGFILES/runtime-$dt.log;

FILES=$INPUT/*
for f in $FILES
    do
        echo $f >> $LOGFILES/runtime-$dt.log
        metamap --fielded_mmi_output $f $OUTPUT/${f##*/}.out
done

metamap $INPUT $OUTPUT/$(basename $FILES).out --fielded_mmi_output

DIFF=$(( $(date +%s) - $T ))
echo "$INPUT took $DIFF seconds"  >> $LOGFILES/runtime-$dt.log;
echo "$INPUT took $DIFF seconds"