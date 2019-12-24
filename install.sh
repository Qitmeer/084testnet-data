## install qitmeer
TAR=qitmeer-0.8.4-darwin-amd64.tar.gz
if [ ! -e ./qitmeer ]; then
  if [ ! -e ./$TAR ]; then
    output=$(wget https://github.com/Qitmeer/qitmeer/releases/download/v0.8.4.1/$TAR 2>&1)
    if [ ! -z "$(echo "$output"|tail -1|grep "saved")" ]; then
      echo download qitmeer ok
    else
      echo "$output"
      exit
    fi
  fi
  tar xf $TAR 2>&1 
  ln -s build/release/darwin/amd64/bin/qitmeer 
  version=$(./qitmeer --version)
  echo install qitmeer $version executble ok 
else
  version=$(./qitmeer --version)
  echo find qitmeer $version executble ok 
fi

## install cli 
CLI=./cli.sh
if [ ! -e $CLI ]; then
  output=$(wget https://raw.githubusercontent.com/Qitmeer/qitmeer/v0.8.4.1/script/cli.sh 2>&1)
  if [ ! -z "$(echo "$output"|tail -1|grep "saved")" ]; then
    echo download qitmeer cli ok
  else
    echo "$output"
    exit
  fi 
  chmod +x $CLI 
  echo install qitmeer cli ok 
else
  chmod +x $CLI 
  echo find qitmeer cli ok 
fi

## install testnet using archive
if [ "$1" == "--use-archive" ]; then
  echo "'--use-archive' mode try to setup your testnet data by using archive data."
  if [ ! -e ./testnet ]; then
    cat testnet0.8.4.part-*|tar xv
  else
    echo "./testnet already exist, please remove the folder manualy and re-run '--use-archive' if you want to overwirte current ./testnet folder"
  fi
fi

