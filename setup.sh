#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/RAL0S/LTE-Cell-Scanner/releases/download/vbef6ef4/LTE-Cell-Scanner.tar.gz -O $RALPM_TMP_DIR/LTE-Cell-Scanner.tar.gz
  tar xf $RALPM_TMP_DIR/LTE-Cell-Scanner.tar.gz -C $RALPM_PKG_INSTALL_DIR/
  rm $RALPM_TMP_DIR/LTE-Cell-Scanner.tar.gz
  chmod +x $RALPM_PKG_INSTALL_DIR/CellSearch
  chmod +x $RALPM_PKG_INSTALL_DIR/LTE-Tracker
  ln -s $RALPM_PKG_INSTALL_DIR/CellSearch $RALPM_PKG_BIN_DIR/CellSearch
  ln -s $RALPM_PKG_INSTALL_DIR/LTE-Tracker $RALPM_PKG_BIN_DIR/LTE-Tracker
  echo "This package adds the command:"
  echo " - CellSearch"
  echo " - LTE-Tracker"

}

uninstall() {
  rm $RALPM_PKG_INSTALL_DIR/CellSearch
  rm $RALPM_PKG_INSTALL_DIR/LTE-Tracker
  rm $RALPM_PKG_BIN_DIR/CellSearch
  rm $RALPM_PKG_BIN_DIR/LTE-Tracker
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1