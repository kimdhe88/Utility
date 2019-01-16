#!/bin/sh
true=1
false=0

init(){
  osName=`uname -s`
  osVersion=`cat /etc/issue | head -1 | awk '{print $1}'`

  if [ "${osName}" != "Linux" ];then
    echo "This script works only on Linux OS."
    return ${false}
  fi

  case ${osVersion} in
    CentOS)
    ;;
    Ubuntu)
    ;;
    *)
      echo "This is an unsupported OS version. [${osVersion}]"
      return ${false}
  esac

  if [ "${USER}" == "root" ];then
    isRoot=${true}
  else
    isRoot=${false}
    printf "Enter the password for the account for the sudo command.";read passwd
  fi

  return ${true}
}

main(){
  init;rstcode=$?
  if [ ${rstcode} -eq ${false} ]; then
    return
  fi

  InstallrationZsh;rstcode=$?
  if [ ${rstcode} -eq ${false} ]; then
    return
  fi
}

InstallrationZsh(){

  if [ -x $(command -v zsh) ];then
    echo "zsh is already installed."
    return ${true}
  else
    case ${osVersion} in
      CentOS)
      InstallCentOS
      ;;
      Ubuntu)
      InstallUbuntu
      ;;
    esac
  fi

  if [ -x $(command -v zsh) ];then
    return ${true}
  else
    return ${false}
  fi
}

InstallCentOS(){
  if [ ${isRoot} -eq "${true}" ];then
    yum install -y zsh
  else
    echo ${passwd} | sudo -S yum install -y zsh
  fi
}

InstallUbuntu(){
  if [ ${isRoot} -eq "${true}" ];then
    apt-get install -y zsh
  else
    apt-get ${passwd} | sudo -S yum install -y zsh
  fi
}

main
