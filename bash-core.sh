#!/bin/bash

#IN NON SUDO MODE
#"gedit ~/.bash_aliases" (add the reference this current bash script file and personal bash files)
#sample example of import at bash aliases file:
#if [ -f /home/user/bash-dump/bash-aliases.sh ]; then
#    . /home/user/bash-dump/bash-aliases.sh
#fi;
#system_init_non_sudo_first
#admin

#SWITCH TO SUDO MODE
#"gedit ~/.bash_aliases" (add the reference this current bash script file and personal bash files)
#system_init_sudo
#"gedit ~/.zshrc" (change the zsh theme to "agnoster" and add the reference this current bash script file and personal bash files)
#sudo -u postgres psql -c 'CREATE EXTENSION IF NOT EXISTS postgis; CREATE EXTENSION IF NOT EXISTS postgis_topology;ALTER USER postgres PASSWORD '$SYSTEM_USER_NAME'; CREATE ROLE $SYSTEM_USER_NAME LOGIN PASSWORD '$SYSTEM_USER_NAME';CREATE USER $SYSTEM_USER_NAME WITH PASSWORD '$SYSTEM_USER_NAME';ALTER ROLE $SYSTEM_USER_NAME SET client_encoding TO 'utf8'; ALTER ROLE $SYSTEM_USER_NAME SET default_transaction_isolation TO 'read committed' ;ALTER ROLE $SYSTEM_USER_NAME SET timezone TO 'UTC';alter role $SYSTEM_USER_NAME superuser;'
#ssh_keygen
#get_ssh (add the ssh public key at Github and Bitbucket)
#ssh_sudo_setup

#SWITCH BACK TO NON SUDO MODE, THAT IS YOUR PERSONAL SYSTEM USER
#system_init_non_sudo_second
#"gedit ~/.zshrc" (change the zsh theme to "agnoster" and add the reference this current bash script file and personal bash files)
#ssh_keygen
#get_ssh (add the ssh public key at Github and Bitbucket)
#ssh_non_sudo_setup
#admin

#SWITCH BACK TO SUDO MODE
#Download smartgit, vscode, pycharm and bracket deb files and put them in the softwares folder. Change the 3 lines below with the latest version the respective softwares. Then run 'install_smartgit', 'install_vscode', 'install_pycharm', 'install_bracket'.
#1. http://www.syntevo.com/smartgit/download
#2. https://code.visualstudio.com/download
#3. https://www.jetbrains.com/pycharm/download/
#4. https://github.com/adobe/brackets/releases/

LATEST_PYCHARM_VERSION="pycharm-community-2017.1.1"
LATEST_SMARTGIT_FILE_NAME="smartgit-17_0_3.deb"
LATEST_VSCODE_FILE_NAME="code-insiders_1.12.0-1492586320_amd64.deb"
LATEST_ROBOMONGO_VERSION="1.0.0"
LATEST_ROBOMONGO_VERSION_FULL="robomongo-$LATEST_ROBOMONGO_VERSION-linux-x86_64-89f24ea"

LATEST_GEOS_VERSION="geos-3.6.1"
LATEST_POSTGIS_VERSION="postgis-2.3.3dev"
LATEST_PYTHON_VERSION="3.5.2"
LATEST_BRACKET_VERSION="1.9"
LATEST_STACER_VERSION="1.0.6"

SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER_NAME="virtual-python-envs"
SYSTEM_ROOT_FOLDER="/home/$SYSTEM_USER_NAME"
BASH_TEMP_FOLDER="$SYSTEM_ROOT_FOLDER/bash-dump"
SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER="$SYSTEM_ROOT_FOLDER/$SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER_NAME"
SYSTEM_ROOT_GIT_REPO_FOLDER="$SYSTEM_ROOT_FOLDER/Gitrepos"
SYSTEM_DOWNLOAD_FOLDER="$SYSTEM_ROOT_FOLDER/Downloads"
SYSTEM_SOFTWARE_FOLDER="$SYSTEM_DOWNLOAD_FOLDER/Softwares"
DEFAULT_PERMISSION_VALUE=777

goToRoot() {
  cd /
}

clearTerminal() {
  clear
  printf "\033c"
  tput reset
  cat /dev/null > ~/.bash_history
}

bashRefresh() {
  source ~/.bash_aliases
  source ~/.zshrc
}

isSudoMode() {
  if [ "$EUID" -ne 0 ] ; then
    echo "0"
    return
  else
    echo "1"
    return
  fi;
}

isFile() {
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  if [ ! -f "$1" ]; then
    return 0
  else
    return 1
  fi;
}

isDir() {
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  if [ -d "$1" ]; then
    return 1
  else
    return 2
  fi;
}

isZsh() {
  if [ $SHELL = "/usr/bin/zsh" ]; then
    return 1
  else
    return 0
  fi;
}

getFunctionName() {
  isZsh
  res=$?
  funcName=""
  if [ "$res" = "1" ] ; then
    funcName=$funcstack[2]
  else
    funcName=${FUNCNAME[1]}
  fi;
  echo $funcName
}

checkIfSudo() {
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"checkIfSudo\"! You must pass the required parameter(s)."
    return "0"
  fi;
  sudoMode=$(isSudoMode)
  if [ "$sudoMode" = "0" ] ; then
    echo "Have to use sudo mode for this method: \"${1}\"."
    return "0"
  fi;
  return "1"
}

checkIfNotSudo() {
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"checkIfNotSudo\"! You must pass the required parameter(s)."
    return "0"
  fi;
  sudoMode=$(isSudoMode)
  if [ "$sudoMode" = "1" ] ; then
    echo "Can not use sudo mode for this method: \"${1}\"."
    return "0"
  fi;
  echo ""
  return "1"
}

checkParameters() {
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"checkParameters\"! You must pass the required parameter(s)."
    return "0"
  fi;
  if [ -z "$2" ]; then
    echo "null value not allowed as second parameter for method: \"checkParameters\"! You must pass the required parameter(s)."
    return "0"
  fi;
  parameterPositions=(first second third fourth fifth sixth seventh eighth ninth tenth)
  for i in {1..${1}}
  do
    j=$((i+2))
    #echo $i $j "${\"$j\"}"
    if [ -z "$j" ]; then
      echo "aaanull value not allowed as ${parameterPositions[i]} parameter for method: \"${2}\"! You must pass the required parameter(s)."
      return "0"
    fi;
  done
  return "1"
}

aptGet() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  sudo apt-get update --fix-missing
  sudo dpkg --configure -a
  sudo apt-get update --fix-missing
}

aptGetUpgrade() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  aptGet
  printf "y\ny\n" | sudo apt-get upgrade
}

coreSystemUpdate() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  aptGet
  printf "y\ny\n" | sudo apt-get upgrade
  aptGet
  printf "y\n" | sudo apt-get dist-upgrade
  aptGet
  printf "y\n" | sudo apt autoremove
  aptGet
}

checkVirtualPythonEnvironmentFolder() {
  goToRoot
  if [ -d "$SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER" ]; then
    cd $SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER/
  else
    cd $SYSTEM_ROOT_FOLDER/
    mkdir $SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER_NAME
    cd $SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER_NAME/
  fi;
}

checkSoftwareFolder() {
  goToRoot
  downloadFolder="$SYSTEM_DOWNLOAD_FOLDER"
  if [ ! -d "$downloadFolder" ]; then
    mkdir $downloadFolder
    chmod $DEFAULT_PERMISSION_VALUE $downloadFolder
  fi;
  cd $downloadFolder/
  softwareFolder="$SYSTEM_SOFTWARE_FOLDER"
  if [ ! -d "$softwareFolder" ]; then
    mkdir $softwareFolder
    chmod $DEFAULT_PERMISSION_VALUE $softwareFolder
  fi;
  cd $softwareFolder/
}

checkAppsFolder() {
  goToRoot
  appsFolder="$SYSTEM_ROOT_FOLDER/Apps/"
  if [ ! -d "$appsFolder" ]; then
    mkdir $appsFolder
    chmod $DEFAULT_PERMISSION_VALUE $appsFolder
  fi;
  cd $appsFolder/
}

nodeUpdates() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  aptGet
  npm install -g mongodb@latest
  npm install -g socket.io@latest
  npm install -g gulp gulp-cli@latest
  npm install -g bower@latest
  npm install -g mocha@latest
  npm install -g coffee-script@latest
  npm install -g karma-cli@latest
  npm install -g nodemon@latest
  npm install -g npm@latest
  npm install -g protractor@latest
  npm install -g firebase-tools@latest
  npm install -g pm2@latest
  npm install -g forever@latest
  npm install -g prettyjson@latest
  npm install -g uglify-js@latest
  npm install -g html-minifier@latest
  npm install -g react@latest
  npm install -g redux@latest
  npm install -g react-redux@latest
  npm install -g redux-devtools@latest
  npm install -g grunt-cli@latest
  webdriver-manager update
}

apmUpdates() {
  printf "yes\n" | apm update
  printf "yes\n" | apm upgrade
}

rcFactoryReset() {
  /bin/cp /etc/skel/.bashrc $SYSTEM_ROOT_FOLDER/
}

rabbitMqRestart() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  rabbitmqctl status
  rabbitmqctl stop
  sudo invoke-rc.d rabbitmq-server start
  rabbitmqctl status
}

postgresPgpassFileInit() {
  funcName=$(getFunctionName)
  checkIfNotSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  if [ ! -f ~/.pgpass ]; then
    touch $USER:$USER ~/.pgpass;
  fi;
  chown $USER:$USER ~/.pgpass
  chmod $DEFAULT_PERMISSION_VALUE ~/.pgpass
  echo -e "localhost:5432:*:postgres:$SYSTEM_USER_NAME\n127.0.0.1:5432:*:postgres:$SYSTEM_USER_NAME\n">~/.pgpass
  echo "Updated pgpass file"
}

changePermissionOfBashrcFiles() {
  chmod $DEFAULT_PERMISSION_VALUE $SYSTEM_ROOT_FOLDER/.zshrc
  chmod $DEFAULT_PERMISSION_VALUE $SYSTEM_ROOT_FOLDER/.bashrc
  chmod $DEFAULT_PERMISSION_VALUE /etc/bash.bashrc
}

openAUrlInBrowser() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  if which xdg-open > /dev/null
  then
    xdg-open $1
  elif which gnome-open > /dev/null
  then
    gnome-open $1
  fi;
}

newDjangoProject() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  django-admin startproject $1 .
}

gitResetHard() {
  branchName="$(git rev-parse --abbrev-ref HEAD)"
  git reset --hard origin/"${branchName}"
}

gitCheckout() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  printf 'yes\n' | git fetch --all
  git checkout $1
  gitResetHard
}

gitRebase() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  printf 'yes\n' | git fetch --all
  git rebase origin/$1
}

getWebsiteData() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  echo `curl $1`
}

findStringPattern() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  if [ -z "$2" ]; then
    echo "null value not allowed as second parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $2
  fi;
  dataString=$1
  dataStringLen=${#dataString}
  startPartternString=$2
  startPartternStringLen=${#startPartternString}
}

installPythonAndPostgres() {
  goToRoot
  aptGet
  printf 'y\n' | sudo apt-get install python-software-properties python-pip python-dev python3-dev libpq-dev postgresql postgresql-contrib pgadmin3 libxml2-dev libxslt1-dev libjpeg-dev python-gpgme postgresql-server-dev-9.5
  printf 'y\n' | sudo apt-get install python-lxml python-cffi libcairo2 libpango1.0-0 libgdk-pixbuf2.0-0 shared-mime-info libxslt-dev libffi-dev libcairo2-dev libpango1.0-dev python3-dev libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
  #geo-spatial packages
  printf 'y\n' | sudo apt-get install binutils libproj-dev gdal-bin libgdal-dev postgis
  checkSoftwareFolder
  wget http://postgis.net/stuff/$LATEST_POSTGIS_VERSION.tar.gz
  tar xvfz $LATEST_POSTGIS_VERSION.tar.gz
  cd $LATEST_POSTGIS_VERSION
  ./configure
  make
  make install
  cd ..
  rm -rf $LATEST_POSTGIS_VERSION.tar.gz
  rm -rf $LATEST_POSTGIS_VERSION
  goToRoot
  pip install --upgrade WeasyPrint
  pip install --upgrade pip
  pip install --upgrade django
  pip install --upgrade virtualenv
  pip install --upgrade jsbeautifier
  pip install --upgrade autopep8
  pip install --upgrade isort
  pip install --upgrade coursera-dl
  pip install --upgrade setuptools
  pip install --upgrade html5lib
  pip install --upgrade docker-compose
  pip install --upgrade awscli
  sudo service postgresql restart
  sudo service postgresql restart
  #the following command is for postgis installation in postgres in 9.3
  #sudo apt-get install postgresql-9.3-postgis-scripts
}

installGeos() {
  #run in sudo mode
  goToRoot
  checkSoftwareFolder
  cd $softwareFolder/
  wget http://download.osgeo.org/geos/$LATEST_GEOS_VERSION.tar.bz2
  tar xjf $LATEST_GEOS_VERSION.tar.bz2
  cd $LATEST_GEOS_VERSION
  ./configure
  make
  printf 'y\n' | sudo make install
  cd ..
  rm -rf $LATEST_GEOS_VERSION
  rm -rf $LATEST_GEOS_VERSION.tar.bz2
  goToRoot
}

installHackLang() {
  goToRoot
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
  printf '\n' | sudo add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
  aptGet
  printf 'y\n' | sudo apt-get install hhvm
}

installPython() {
  #latest python version
  mkdir /opt/python3.5
  cd /opt/python3.5
  wget https://www.python.org/ftp/python/$LATEST_PYTHON_VERSION/Python-$LATEST_PYTHON_VERSION.tgz
  sudo tar xzf Python-$LATEST_PYTHON_VERSION.tgz
  cd Python-$LATEST_PYTHON_VERSION
  sudo ./configure
  sudo make altinstall
  python3.5 -V
}

installHipchat() {
  goToRoot
  aptGet
  # Dependent on ubuntu version
  sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
  wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
  aptGet
  printf 'y\n' | sudo apt-get install hipchat4
}

installBracket() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  aptGet
  checkSoftwareFolder
  wget https://github.com/adobe/brackets/releases/download/release-$1/Brackets.Release.$1.64-bit.deb
  printf 'y\n' | sudo apt install Brackets.Release.$1.64-bit.deb
  sudo dpkg -i Brackets.Release.$1.64-bit
  printf 'y\n' | sudo apt-get install -f
  goToRoot
}

installBlender() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  aptGet
  printf '\n' | sudo add-apt-repository ppa:thomas-schiex/blender
  aptGet
  printf 'y\n' | sudo apt install blender
  goToRoot
}

installVisualStudioCode() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  goToRoot
  aptGet
  checkSoftwareFolder
  printf 'y\n' | sudo apt-get install gvfs-bin
  #wget --no-check-certificate https://az764295.vo.msecnd.net/stable/e6b4afa53e9c0f54edef1673de9001e9f0f547ae/code_1.3.1-1468329898_amd64.deb
  sudo dpkg -i $1
  rm -rf $1
  goToRoot
}

installVSCodeExtensionsNonSudo() {
  code --install-extension ms-vscode.cpptools
  code --install-extension ms-vscode.csharp
  code --install-extension robertohuertasm.vscode-icons
  code --install-extension PeterJausovec.vscode-docker
  code --install-extension Shan.code-settings-sync
  code --install-extension donjayamanne.githistory
  code --install-extension donjayamanne.python
  code --install-extension hnw.vscode-auto-open-markdown-preview
  code --install-extension nwallace.peep
  code --install-extension streetsidesoftware.code-spell-checker
  code --install-extension waderyan.gitblame
  code --install-extension msjsdiag.debugger-for-chrome
  code --install-extension HookyQR.beautify
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension lukehoban.Go
  code --install-extension abusaidm.html-snippets
  code --install-extension ms-vscode.PowerShell
  code --install-extension eg2.tslint
  code --install-extension johnpapa.Angular2
  code --install-extension zhuangtongfa.Material-theme
  code --install-extension xabikos.JavaScriptSnippets
  code --install-extension formulahendry.code-runner
  code --install-extension redhat.java
  code --install-extension felixfbecker.php-debug
  code --install-extension magicstack.MagicPython
  code --install-extension Shan.code-settings-sync
  code --install-extension Zignd.html-css-class-completion
}

installDotNetCore() {
  goToRoot
  # Dependent on ubuntu version
  sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ "$(lsb_release -sc)" main" > /etc/apt/sources.list.d/dotnetdev.list'
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
  aptGet
  printf 'y\n' | sudo apt-get install dotnet-dev-1.0.1
  goToRoot
}

installMongoDb() {
  goToRoot
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
  # Dependent on ubuntu version
  echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
  aptGet
  printf 'y\n' | sudo apt-get install -y mongodb-org
  sudo service mongod start
  goToRoot
}

powerlineFontInstallationSudo() {
  goToRoot
  aptGet
  checkSoftwareFolder
  wget --no-check-certificate https://github.com/powerline/fonts/archive/master.zip
  unzip master.zip
  sh fonts-master/install.sh
  rm -rf master.zip
  rm -rf fonts-master
  fc-cache -f -v
  goToRoot
}

powerlineFontInstallationNonSudo() {
  goToRoot
  checkSoftwareFolder
  wget --no-check-certificate https://github.com/powerline/fonts/archive/master.zip
  unzip master.zip
  sh fonts-master/install.sh
  rm -rf master.zip
  rm -rf fonts-master
  fc-cache -f -v
  goToRoot
}

installZshSudo() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  aptGet
  rm -rf /root/.oh-my-zsh
  pip install --user powerline-status
  powerlineFontInstallation
  printf '\n' | sudo apt-get install zsh
  goToRoot
  checkSoftwareFolder
  #in both sudo and non sudo mode(the below two lines of code only)
  #sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" (either this line or the one below)
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
  chsh -s /usr/bin/zsh
  goToRoot
  source ~/.zshrc
  source ~/.bashrc
}

installSmartgit() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  checkSoftwareFolder
  printf 'y\n' | sudo apt install $1
  sudo dpkg -i $1
  printf 'y\n' | sudo apt-get install -f
}

installRedis() {
  isSudoMode
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  checkSoftwareFolder
  wget http://download.redis.io/redis-stable.tar.gz
  tar xvzf redis-stable.tar.gz
  cd redis-stable
  make
  printf 'y\n' | sudo make install
  rm -rf redis-stable.tar.gz
  goToRoot
}

installRoboMongo() {
  isSudoMode
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  if [ -z "$2" ]; then
    echo "null value not allowed as second parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $2
  fi;
  goToRoot
  checkSoftwareFolder
  wget https://download.robomongo.org/$1/linux/$2.tar.gz
  tar -xvzf $2.tar.gz
  sudo mkdir /usr/local/bin/robomongo
  sudo mv $2/* /usr/local/bin/robomongo
  cd /usr/local/bin/robomongo/bin
  sudo chmod +x robomongo ## run command only if robomongo isn't excutable file
  ./robomongo
  goToRoot
}

installPyCharm() {
  funcName=$(getFunctionName)
  checkIfNotSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  checkSoftwareFolder
  tar xvfz $1.tar.gz
  mkdir $SYSTEM_ROOT_FOLDER/Apps/$1
  rm -rf $SYSTEM_ROOT_FOLDER/Apps/$1
  mv "$1" "$SYSTEM_ROOT_FOLDER/Apps/$1"
  rm -rf "$1"
}

installZshNonSudo() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  aptGet
  rm -rf $SYSTEM_ROOT_FOLDER/.oh-my-zsh
  pip install --user powerline-status
  goToRoot
  checkSoftwareFolder
  #sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" (either this line or the one below)
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
  chsh -s /usr/bin/zsh
  goToRoot
  source ~/.zshrc
  source ~/.bashrc
}

installAtom() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  aptGet
  printf '\n' | sudo add-apt-repository ppa:webupd8team/atom
  aptGet
  printf 'y\n' | sudo apt-get install atom
  #ALTERNATE METHOD BELOW(commented out)
  #checkSoftwareFolder
  #wget --no-check-certificate https://atom.io/download/deb
  #mv "deb" "atom-amd64.deb"
  #sudo dpkg -i atom-amd64.deb
  #sudo apt-get install -f
  #rm -rf atom-amd64.deb
  apm install nuclide
  apm install atom-beautify
  apm install autocomplete-python
  apm install color-picker
  apm install emmet
  apm install file-icons
  apm install git-plus
  apm install linter
  apm install linter-eslint
  apm install minimap
  apm install pigments
  apm install project-manager
  apm install script
  apm install merge-conflicts
  apm install atom-typescript
  apm install activate-power-mode
  #apm install language-babel
  apm install highlight-selected
  #apm install react
  apm install autoclose-html
  goToRoot
}

installSmartgitByCrawl() {
  funcName=$(getFunctionName)
  # TODO: finish this implementation
  # Download the smartgit from website first and place it in the downloads folder
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  fileName=""
  startPartternString="<a href=\"./download?file=smartgit"
  endPartternString="\""
  dataString=$(getWebsiteData "http://www.syntevo.com/smartgit/download")
  dataStringLen=${#dataString}
  startPartternStringLen=${#startPartternString}
  endPartternStringLen=${#endPartternString}
  dataStringLen=$(($dataStringLen-1))
  for i in {0..$dataStringLen}; do
    limitEnd=$(($i+$startPartternStringLen-1))
    substring=''
    for j in {$i..$limitEnd}; do
      singleChar=${dataString:$j:1}
      substring=$substring$singleChar
    done
    if [[ "$substring" == "$startPartternString" ]]; then
      #res=''
      #limitStart=$(($limitEnd+1))
      #substring=''
      #for j in {$limitStart..$dataStringLen}; do
      #  singleChar=${dataString:$j:1}
      #  substring=$substring$singleChar
      #done
      echo "$substring"
    fi
  done
  printf 'y\n' | sudo apt install $fileName
  sudo dpkg -i $fileName
  printf 'y\n' | sudo apt-get install -f
}

installStacer() {
  funcName=$(getFunctionName)
  if [ -z "$1" ]; then
    echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
    return $1
  fi;
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  aptGet
  checkSoftwareFolder
  wget https://github.com/oguzhaninan/Stacer/releases/download/v$1/Stacer_$1_amd64.deb
  printf 'y\n' | sudo apt install $SYSTEM_SOFTWARE_FOLDER/Stacer_$1_amd64.deb
  sudo dpkg -i Stacer_$1_amd64.deb
  printf 'y\n' | sudo apt-get install -f
  goToRoot
}

installJenkins() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  aptGet
  checkSoftwareFolder
  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  aptGet
  printf 'Y\n' | sudo apt-get install jenkins
  goToRoot
}

installPhpmyadmin() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  printf 'y\n' | sudo apt-get install mysql-server
  sudo mysql_secure_installation
  printf 'y\n' | sudo apt-get install phpmyadmin php-mbstring php-gettext
  #https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-16-04
}

installLaravelNonSudo() {
  funcName=$(getFunctionName)
  checkIfNotSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  composer global require "laravel/installer"
  echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bash_aliases
  bash_refresh
  #http://vaguelyuseful.info/2016/08/03/installing-laravel-5-2-on-ubuntu-16-04-and-apache2/
}

installSkype() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  dpkg -s apt-transport-https > /dev/null || bash -c "sudo apt-get update; sudo apt-get install apt-transport-https -y"
  curl https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add -
  echo "deb [arch=amd64] https://repo.skype.com/deb stable main" | sudo tee /etc/apt/sources.list.d/skype-stable.list
  aptGet
  sudo apt-get install skypeforlinux -y
}

installGnome() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  printf 'y\n' | sudo apt-get install gnome
  printf 'y\n' | sudo apt-get install gnome-shell
  printf 'y\n' | sudo apt install gnome-control-center gnome-online-accounts
}

installRabbitMq() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
  wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
  aptGet
  printf 'y\n' | sudo apt-get install rabbitmq-server
}

installWine() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  printf 'y\n' | sudo apt remove wine2.0 wine-staging wine wine1.8 wine-stable libwine* fonts-wine* && sudo apt autoremove
  printf '\n' | sudo add-apt-repository --remove ppa:wine/wine-builds
  wget https://dl.winehq.org/wine-builds/Release.key
  sudo apt-key add Release.key
  sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'
  aptGet
  printf 'y\n' | sudo apt-get install --install-recommends wine-staging
  /opt/wine-staging/bin/wine
  /opt/wine-staging/bin/winecfg
}

installMonoDevelop() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  printf '\n' | sudo add-apt-repository ppa:alexlarsson/flatpak
  aptGet
  printf 'y\n' | sudo apt install flatpak
  printf 'y\n' | flatpak install --user --from https://download.mono-project.com/repo/monodevelop.flatpakref
}

installPhp() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  aptGet
  printf 'y\n' | sudo apt-get install apache2
  aptGet
  printf 'y\n' | sudo apt-get install apache2 php7.0 libapache2-mod-php7.0
  aptGet
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
  aptGet
  sudo phpenmod mcrypt
  sudo phpenmod mbstring
  sudo a2enmod rewrite
  sudo systemctl restart apache2
}

installDocker() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  aptGet
  printf "y\n" | sudo apt-get install apt-transport-https ca-certificates
  printf "y\n" | sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  printf 'y\n' | sudo apt-get install docker-ce
  #sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  #aptGet
  # Dependent on ubuntu version
  #printf '\n' | sudo add-apt-repository 'deb https://apt.dockerproject.org/repo ubuntu-"$(lsb_release -sc)" main'
  #printf 'y\n' | sudo apt-get install docker-engine
  #sudo apt-cache policy docker-engine
  sudo service docker start
  usermod -aG docker ${USER}
}

installHerokuToolbelt() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  aptGet
  #wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
  printf '\n' | sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
  curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
  aptGet
  printf 'y\n' | sudo apt-get install heroku
}

installVirtualBox() {
  # Install virtual-box
  printf 'y\n' | sudo apt install virtualbox virtualbox-ext-pack
}

installJava() {
  # Install Java 9
  printf '\n' | sudo add-apt-repository ppa:webupd8team/java
  aptGet
  sudo apt-get install oracle-java9-installer
}

installPackagesForSystemSudo() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  goToRoot
  coreSystemUpdate
  # Install build essentials
  printf 'y\n' | sudo apt-get install build-essential autoconf automake unzip curl gcc g++ wget sshpass tree git zip upstart preload nano vim lsof
  printf 'y\n' | sudo apt-get install ubuntu-desktop unity compizconfig-settings-manager checkinstall curl software-properties-common libav-tools ffmpeg
  # Install ubuntu make
  printf '\n' | sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
  aptGet
  # Install open vpn
  printf '\n' | sudo apt-get install openvpn easy-rsa
  aptGet
  printf 'y\n' | sudo apt-get install ubuntu-make
  # Install Git
  printf 'y\n' | sudo apt-get install git git-core xclip
  git config --global user.name $SYSTEM_USER_FULL_NAME
  GIT_COMMITTER_NAME=$SYSTEM_USER_FULL_NAME
  GIT_AUTHOR_NAME=$SYSTEM_USER_FULL_NAME
  git config --global user.email $SYSTEM_USER_EMAIL
  GIT_COMMITTER_EMAIL=$SYSTEM_USER_EMAIL
  GIT_AUTHOR_EMAIL=$SYSTEM_USER_EMAIL
  # Install NodeJS and NPM along with required global node modules
  aptGet
  curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
  sudo apt-get install -y nodejs
  nodeUpdates
  # Install python and postgres
  installPythonAndPostgres
  # Install C++ code beautifier
  printf 'y\n' | sudo apt-get install uncrustify
  # Install tweak tool
  printf 'y\n' | sudo apt-get install unity-tweak-tool gnome-tweak-tool
  aptGet
  # Install youtube video downloader
  printf 'y\n' | sudo apt-get install youtube-dl
  # Install Codeblocks
  printf 'y\n' | sudo apt-get install codeblocks
  # Install expect
  printf "y\n" | sudo apt-get install expect expect-dev
  # Install media players
  aptGet
  printf "y\n" | sudo apt-get install banshee
  printf "\n" | sudo add-apt-repository ppa:me-davidsansome/clementine
  aptGet
  printf "y\n" | sudo apt-get install clementine
  # Install Etcher
  touch /etc/apt/sources.list.d/etcher.list
  echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | tee /etc/apt/sources.list.d/etcher.list
  sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61
  aptGet
  printf "y\n" | sudo apt-get install etcher-electron
  # Install Spotify
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
  echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
  aptGet
  printf "y\n" | sudo apt-get install spotify-client
  # Install New fetch
  printf "\n" | sudo add-apt-repository ppa:dawidd0811/neofetch
  aptGet
  printf "y\n" | sudo apt install neofetch
  # Install Steam
  # printf 'y\n' | sudo apt-get install steam
  #Install Adobe Flash Player
  printf 'y\n' | sudo apt-get install flashplugin-installer
  # Install Filezilla FTP
  printf 'y\n' | sudo apt-get install filezilla
  # Install VLC
  printf 'y\n' | sudo apt-get install vlc browser-plugin-vlc
  # Install sublime text 3
  printf '\n' | sudo add-apt-repository ppa:webupd8team/sublime-text-3
  aptGet
  printf 'y\n' | sudo apt-get install sublime-text-installer
  # Install Atom
  installAtom
  # Install Unrar
  printf 'y\n' | sudo apt-get install unrar
  # Install Transmission client
  printf '\n' | sudo add-apt-repository ppa:transmissionbt/ppa
  aptGet
  printf 'y\n' | sudo apt-get install transmission-gtk transmission-cli transmission-common transmission-daemon
  # Install GIMP
  printf 'y\n' | sudo apt-get install gimp gimp-data gimp-plugin-registry gimp-data-extras
  aptGet
  # Install postgis
  printf "y\n" | sudo apt-get install postgis
  # Install Synaptic
  printf 'y\n' | sudo apt-get install synaptic
  # Install Laptop mode tools
  printf 'y\n' | sudo apt-get install laptop-mode-tools
  # Install microphone control panel
  printf 'y\n' | sudo apt-get install pavucontrol
  # Stacer installation
  installStacer $LATEST_STACER_VERSION
  # Docker installation
  installDocker
  # Install Heroku toolbelt
  installHerokuToolbelt
  # Install Jenkins
  installJenkins
  # Install mono develop
  installMonoDevelop
  # Install line of code count for git repo
  aptGet
  printf 'y\n' | sudo apt-get install cloc
  # Install php
  installPhp
  # Install skype
  aptGet
  installSkype
  # Install Redis
  installRedis
  # Install rabbit mq
  aptGet
  installRabbitMq
  rabbitMqRestart
  # Install Geos
  installGeos
  # Install powerline fonts
  powerlineFontInstallationSudo
  # Install ZSH
  aptGet
  installZshSudo
  # Install blender
  installBlender
  # Install ngnix
  sudo service apache2 stop
  printf "y\n" | sudo apt-get install nginx
  sudo ufw allow 'Nginx Full'
  sudo ufw allow 'Nginx HTTP'
  sudo ufw allow 'Nginx HTTPS'
  sudo service apache2 start
  coreSystemUpdate
}

installPackagesForSystemNonSudoFirst() {
  funcName=$(getFunctionName)
  checkIfNotSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  checkVirtualPythonEnvironmentFolder
  checkSoftwareFolder
  checkAppsFolder
}

installPackagesForSystemSudoSecond() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  installPackagesForSystemSudo
}

installPackagesForSystemNonSudoThird() {
  funcName=$(getFunctionName)
  checkIfNotSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  installZshNonSudo
  powerlineFontInstallationNonSudo
  installVSCodeExtensionsNonSudo
  postgresPgpassFileInit
}

sshOperationsSudo() {
  funcName=$(getFunctionName)
  checkIfSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  ssh_agent_verify
  ssh_agent_add_root
  github_keyscan_sudo
  bitbucket_keyscan_sudo
  github_auth
  bitbucket_auth
}

sshOperationsNonSudo() {
  funcName=$(getFunctionName)
  checkIfNotSudo $funcName
  if [ "${?}" = "0" ] ; then
    return
  fi;
  ssh_agent_verify
  ssh_agent_add
  github_keyscan_non_sudo
  bitbucket_keyscan_non_sudo
  github_auth
  bitbucket_auth
}

nodeExpressNpmInitiation() {
  npm install express@latest --save
  npm install body-parser@latest --save
  npm install cookie-parser@latest --save
  npm install multer@latest --save
  npm install nodemailer@latest --save
  npm install file-stream-rotator@latest --save
  npm install morgan@latest --save
  npm install connect@latest --save
  npm install body-parser@latest --save
  npm install compression@latest --save
  npm install cookie-parser@latest --save
  npm install cookie-session@latest --save
  npm install csurf@latest --save
  npm install errorhandler@latest --save
  npm install express-session@latest --save
  npm install method-override@latest --save
  npm install response-time@latest --save
  npm install serve-favicon@latest --save
  npm install serve-index@latest --save
  npm install serve-static@latest --save
  npm install vhost@latest --save
  npm install pm2@latest --save
  npm install forever@latest --save
  npm install winston@latest --save
  npm install raven@latest --save
  npm install helmet@latest --save
  npm install cron@latest --save
  npm install uglify-js@latest --save
  npm install html-minifier@latest --save
}

alias admin='sudo -i'
alias allow_port_sudo='sudo ufw allow '
alias apache_reload='/etc/init.d/apache2 reload'
alias apt_get=aptGetUpgrade
alias atom_up=apmUpdates
alias bash_refresh=bashRefresh
alias bitbucket_auth='printf "yes\n" | ssh -T git@bitbucket.com'
alias bitbucket_keyscan_non_sudo="ssh-keyscan -t rsa bitbucket.com >> $SYSTEM_ROOT_FOLDER/.ssh/known_hosts"
alias bitbucket_keyscan_sudo='ssh-keyscan -t rsa bitbucket.com >> /root/.ssh/known_hosts'
alias brc='~/.bashrc'
alias check_ubuntu_version='lsb_release -a'
alias cls='clearTerminal'
alias cls_root='clearTerminal && goToRoot'
alias downloads="cd $SYSTEM_DOWNLOAD_FOLDER"
alias erc='/etc/bash.bashrc'
alias fb_d='firebase deploy'
alias fb_i='firebase init'
alias fb_l='firebase list'
alias fb_lo='firebase login'
alias fb_o='firebase open'
alias fb_s='firebase serve'
alias fb_v='firebase --version'
alias firewall_list='sudo ufw app list'
alias filewall_status="sudo ufw status"
alias forever_list='forever list'
alias forever_restart='forever restart 0'
alias fperm='stat -c "%a %n" '
alias gbrc='gedit ~/.bashrc'
alias gerc='gedit /etc/bash.bashrc'
alias get_ssh='cat ~/.ssh/id_rsa.pub | xclip -sel clip'
alias git_a='git add '
alias git_b='git_f && git rev-parse --abbrev-ref HEAD'
alias git_c=gitCheckout
alias git_cc='git commit -m "Rebased and resolved conflicts after rebasing from base branch."'
alias git_f='printf "yes\n" | git fetch --all'
alias git_l='git_f && git log'
alias git_p='git push origin HEAD -f'
alias git_r=gitRebase
alias git_rc='git rebase --continue'
alias git_remove_last_commit='git reset --hard HEAD^'
alias git_rh='git_f && gitResetHard'
alias git_rl='git_f && git reflog'
alias git_s='git_f && git status'
alias git_set_name="git config --global user.name '$SYSTEM_USER_FULL_NAME'"
alias git_set_email="git config --global user.email '$SYSTEM_USER_EMAIL'"
alias github_auth='printf "yes\n" | ssh -T git@github.com'
alias github_keyscan_non_sudo="ssh-keyscan -t rsa github.com >> $SYSTEM_ROOT_FOLDER/.ssh/known_hosts"
alias github_keyscan_sudo='ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts'
alias gpg_config='git config --global gpg.program gpg2'
alias gpg_export='gpg --armor --export'
alias gpg_gen='gpg --gen-key'
alias gpg_list='gpg --list-secret-keys --keyid-format LONG'
alias gpg_sign='git config --global user.signingkey'
alias gzrc='gedit ~/.zshrc'
alias home='cd ~/'
alias install_atom=installAtom
alias install_blender=installBlender
alias install_bracket="installBracket $LATEST_BRACKET_VERSION"
alias install_hack_lang=installHackLang
alias install_java=installJava
alias install_mongo=installMongoDb
alias install_pycharm="installPyCharm $LATEST_PYCHARM_VERSION"
alias install_python_postgres=installPythonAndPostgres
alias install_robo_mongo="installRoboMongo $LATEST_ROBOMONGO_VERSION $LATEST_ROBOMONGO_VERSION_FULL"
alias install_smartgit="installSmartgit $LATEST_SMARTGIT_FILE_NAME"
alias install_virtual_box=installVirtualBox
alias install_vscode="installVisualStudioCode $LATEST_VSCODE_FILE_NAME"
alias jenkins_install=installJenkins
alias jenkins_start='/etc/init.d/jenkins start'
alias jenkins_stop='/etc/init.d/jenkins stop'
alias karma_test='karma start --browsers Chrome'
alias loc_count='cloc '
alias no_sudo_zsh='export SHELL=/usr/bin/zsh && exec /usr/bin/zsh -l'
alias node_update=nodeUpdates
alias pc="cd $SYSTEM_ROOT_FOLDER && sh $SYSTEM_ROOT_FOLDER/Apps/$LATEST_PYCHARM_VERSION/bin/pycharm.sh"
alias pip_freeze='pip freeze > requirements.txt'
alias pip_init='pip install django psycopg2 djangorestframework markdown django-filter dj-database-url whitenoise django-nose nose djangorestframework gunicorn pytz mock django-celery django-celery-results && pip_freeze'
alias pip_update='pip install --upgrade pip'
alias postgres_pgpass_file=postgresPgpassFileInit
alias postgres_restart='sudo service postgresql restart'
alias postgres_shell='psql -U postgres'
alias postgres_shell_sudo='sudo -u postgres psql'
alias protractor_test='protractor conf.js'
alias proxy_remove="kill -9 $(ps -efda | grep ssh | tail -n1 | awk '{print $2}')"
alias python_postgres_init='install_python_postgres && postgres_pgpass_file && postgres_restart'
alias rc_factory_reset=rcFactoryReset
alias redis_check='redis-cli ping'
alias redis_start='nohup redis-server &'
alias redis_stop='redis-cli shutdown'
alias root='goToRoot'
alias service_details='systemctl status '
alias sg="cd $SYSTEM_ROOT_FOLDER && sh $SYSTEM_ROOT_FOLDER/Apps/smartgit/bin/smartgit.sh"
alias ssh_agent_add='ssh-add ~/.ssh/id_rsa'
alias ssh_agent_add_root='ssh-add /root/.ssh/id_rsa'
alias ssh_agent_verify='eval "$(ssh-agent -s)"'
alias ssh_keygen='ssh-keygen -t rsa -b 4096 -C "$SYSTEM_USER_EMAIL"'
alias ssh_non_sudo_setup=sshOperationsNonSudo
alias ssh_sudo_setup=sshOperationsSudo
alias system_init_non_sudo_first=installPackagesForSystemNonSudoFirst
alias system_init_non_sudo_second=installPackagesForSystemNonSudoThird
alias system_init_sudo=installPackagesForSystemSudoSecond
alias tar_install='tar -xzf '
alias up='cd ..'
alias zrc='~/.zshrc'
