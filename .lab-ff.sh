#!/bin/bash -e

export DEFAULT_WEBSERVER="http://localhost:8081"
export WEBSERVER="${WEBSERVER:-$DEFAULT_WEBSERVER}"

if [[ -z $1 ]]; then
    echo "Please provide a lab number or \"reset\". Example: lab-ff 3"
    exit 0
fi

if [ $1 == "reset" ]
then
    FF_LAB=0
else
    FF_LAB=$(($1))
fi

WORKDIR=$HOME/.lab-ff

pushd `pwd` > /dev/null

if [ ! -d "$WORKDIR" ] 
then
    mkdir -p $WORKDIR
    cd $WORKDIR

    curl -s ${WEBSERVER}/_static/lab-files.tar.gz | tar -xzv

    curl -s ${WEBSERVER}/_static/solutions.tar.gz | tar -xzv
fi

for (( currentLabNum=0; currentLabNum<=$FF_LAB; currentLabNum++ ))
do

    # skip playing the reset lab logic unless we intentionally choose it 
    if (( $FF_LAB != 0 )) && (( $currentLabNum == 0 ))
    then
        continue
    fi

    currentLabStr=$(printf "%02d" $currentLabNum)
    if [ -f "$WORKDIR/solutions/lab$currentLabStr/code/run.sh" ]
    then
        cd "$WORKDIR/solutions/lab$currentLabStr/code"
        echo "Playing lab$currentLabStr"
        chmod 755 run.sh && ./run.sh
    else
        echo "Skipping lab$currentLabStr, nothing to do"
    fi
done

popd > /dev/null

echo "Finished fast forwarding"