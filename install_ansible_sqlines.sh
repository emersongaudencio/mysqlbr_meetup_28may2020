#!/bin/bash
#### install python3 #####
verify_python=`rpm -qa | grep python3-3`
if [[ "${verify_python}" == "python3-3"* ]] ; then
   echo "$verify_python is installed!"
else
   yum -y install python3
fi

#### install git #####
verify_git=`rpm -qa | grep git-1`
if [[ "${verify_git}" == "git"* ]] ; then
   echo "$verify_git is installed!"
else
   yum install git -y
fi

#### install pip #####
verify_pip=`pip -V`
if [[ "${verify_pip}" == "pip"* ]] ; then
   echo "$verify_pip is installed!"
   echo "Pip-Path: $(which pip)"
else
   curl -sS https://bootstrap.pypa.io/get-pip.py | python3
   source ~/.bashrc
   pip -V
   echo "Pip-Path: $(which pip)"
fi

#### install ansible #####
verify_ansible=`ansible --version`
if [[ "${verify_ansible}" == "ansible"* ]] ; then
  echo "$verify_ansible is installed!"
  echo "Ansible-Path: $(which ansible)"
else
  python3 -m pip install ansible
  source ~/.bashrc
  ansible --version
  echo "Ansible-Path: $(which ansible)"
fi

### mariadb install ###
if [[ -d "/opt/ansible-oracle-to-mariadb-migration" ]] ; then
  echo "Directory /opt/ansible-oracle-to-mariadb-migration exists."
else
  cd /opt
  git clone https://github.com/emersongaudencio/ansible-oracle-to-mariadb-migration.git
  cd ansible-oracle-to-mariadb-migration
  sed -ie 's/ansible/\/usr\/local\/bin\/ansible/g' run_sqlines.sh
  bash run_sqlines.sh sqlines-local mysqlines
fi
