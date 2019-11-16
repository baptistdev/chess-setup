#!/bin/sh

#################################################
#    Preparing Repository Configuration         #
#################################################
ROOT=~/chess/elixir
mkdir -p $ROOT
mkdir -p $ROOT/downloads
mkdir -p $ROOT/runtime
mkdir -p $ROOT/instances/elixir_01
INSTANCE_HOME=~/chess/elixir/instances/elixir_01
file=$INSTANCE_HOME/config.prp
if [ -f "$file" ]; then
   echo "File $file exists,loading configuration."
else
echo "Provide the repository details:" 
echo "Enter repository:" 
read localrepo
echo "localREPO="$localrepo >> $INSTANCE_HOME/config.prp
echo "Enter user:"
read localuser
echo "localREPOUNCUser="$localuser >> $INSTANCE_HOME/config.prp
echo "Enter password:"
read localpwd
echo "localREPOUNCPwd="$localpwd >> $INSTANCE_HOME/config.prp
echo "Enter domain:"
read localdomain
echo "localREPOUNCDomain="$localdomain >> $INSTANCE_HOME/config.prp
echo "Enter git user:"
read gituser
echo "gitUser="$gituser >> $INSTANCE_HOME/config.prp
echo "Enter git Email:"
read gitemail
echo "gitEmail="$gitemail >> $INSTANCE_HOME/config.prp
echo "Enter remote repository:"
read remoterepo
echo "remoteREPO="$remoterepo >> $INSTANCE_HOME/config.prp
echo "Enter remote repository http user:"
read remoterepohttpuser
echo "remoteREPOHTTPSUser="$remoterepohttpuser >> $INSTANCE_HOME/config.prp
echo "Enter remote repository http password:"
read remoterepohttppwd
echo "remoteREPOHTTPSPwd="$remoterepohttppwd >> $INSTANCE_HOME/config.prp
echo "instancename=elixir_01" >> $INSTANCE_HOME/config.prp
fi
. $INSTANCE_HOME/config.prp

###################################################
#    Download Installation files                  #
###################################################

cd $ROOT/downloads
mkdir -p $INSTANCE_HOME/tmp
if [ -f $INSTANCE_HOME/tmp/download.log ]; then
   read -p "XAMPP and JAVA already downloaded"
   sleep 4
else
read -p "download started, Press enter to continue"
sleep 4
#XAMPP
wget https://www.apachefriends.org/xampp-files/7.3.11/xampp-linux-x64-7.3.11-0-installer.run
status=$?
if [ $status -eq 0 ]; then
   echo "XAMPP_DOWNLOAD=yes" >> $INSTANCE_HOME/tmp/download.log
   read -p "XAMPP download complete, Press enter to continue"
   sleep 4
else
   echo "XAMPP_DOWNLOAD=no" >> $INSTANCE_HOME/tmp/download.log
fi

#JAVA
wget https://download.java.net/openjdk/jdk13/ri/openjdk-13+33_linux-x64_bin.tar.gz
status=$?
if [ $status -eq 0 ]; then
   echo "JAVA_DOWNLOAD=yes" >> $INSTANCE_HOME/tmp/download.log
   read -p "JAVA download complete, Press enter to continue"
   sleep 4
else
   echo "JAVA_DOWNLOAD=no" >> $INSTANCE_HOME/tmp/download.log
fi
fi

###################################################
#   Installation                                  #
###################################################

read -p "installation started, Press enter to continue"
 sleep 4
#git
i=$(which git | wc -c)
if [ $i -ne 0 ]; then
   echo "git already installed"
else
   sudo apt-get update
   sudo apt-get install git-core
   read -p "git install complete, Press enter to continue"
   sleep 4
fi

#node
n=$(which node | wc -c)
if [ $n -ne 0 ]; then
   echo "node already installed"
   sleep 4
else
   ls ~/.nvm
   nv=$? 
   if [ $nv -eq 0 ]; then
      echo "alredy nvm installed"
      sleep 4
   else
      cd ~
      git clone https://github.com/creationix/nvm.git .nvm
   fi
   cd ~/.nvm
   git checkout v0.33.9
   . ./nvm.sh
   nvm install 10.17.0
   sleep 5 
   nvm use 10.17.0
   read -p "node install complete, Press enter to continue"
   sleep 4
fi

#vscode
c=$(which vscode | wc -c)
if [ $c -ne 0 ]; then
   echo "code already installed"
   sleep 4
else
   sudo apt install snapd
   sudo snap install vscode --classic
fi

#xampp
ls /opt
st=$?
if [ $st -eq 0 ]; then
   echo "xampp already installed"
   sleep 4
else
   cd $ROOT/downloads
   chmod +x ./xampp-linux-x64-7.3.11-0-installer.run
   sudo ./xampp-linux-x64-7.3.11-0-installer.run
   read -p "xampp install complete, Press enter to continue"
fi

#java
j=$(which java | wc -c)
if [ $j -ne 0 ]; then
   echo "java already installed"
   sleep 4
else
   cd $ROOT/downloads
   tar -xzf openjdk-13+33_linux-x64_bin.tar.gz -C $ROOT/runtime
   read -p "code install complete, Press enter to continue"
   sleep 4
fi
   nvm use 10.17.0

#########################################################
#         Clone Repository modules                      #
#########################################################

read -p "repository cloning started, Press enter to continue"
sleep 4
git config --global --add user.name $gitUser
git config --global --add user.email $gitEmail
mkdir -p ~/repos
sudo mount //$localREPO/repos ~/repos -o username=$localREPOUNCUser,password=$localREPOUNCPwd,domain=$localREPOUNCDomain,vers=2.1
cd $INSTANCE_HOME
for module in ember-masonry-grid bbhverse loopback qms ember-searchable-select loopback-component-jsonapi config loopback-connector-ds
do
    git clone ~/repos/$module.git
done
read -p "cloning modules complete, Press enter to continue"
sleep 4

#########################################################
#       Install Ember                                   #
#########################################################

echo "Installing ember"
sleep 4
npm install -g ember-cli
echo "Ember install completed"
sleep 4


#########################################################
#        Installing Repository modules                  #
#########################################################

read -p "repository installation started, Press enter to continue"
sleep 4
for install in loopback qms qms/server
do
    cd $INSTANCE_HOME/$install
    npm install
done
read -p "modules install complete, Press enter to continue"
sleep 4

#########################################################
#       Bower install                                   #
#########################################################

read -p "bower installation started, Press enter to continue"
sleep 4
cd $INSTANCE_HOME/qms
usr=$(whoami)
sudo chown -R $usr ~/.cache
sudo chown -R $usr ~/.config
./node_modules/.bin/bower install
read -p "bower install complete, Press enter to continue"
sleep 4

mkdir -p $INSTANCE_HOME/qms/bower_components/materialize/dist/fonts 
cp -r ~/repos/roboto $INSTANCE_HOME/qms/bower_components/materialize/dist/fonts

###########################################################
#       Intialize Database Schema                        #
###########################################################

sudo /opt/lampp/xampp start
cd /opt/lampp/bin
sleep 3
sudo ./mysql -h localhost -u root -p -e "CREATE DATABASE elixir;"
rsync -r $INSTANCE_HOME/loopback/common/models/ $INSTANCE_HOME/loopback/common/schemaBuilderSource
cd  $INSTANCE_HOME/loopback
mkdir -p  $INSTANCE_HOME/loopback/qms/data/filestore
NODE_ENV=devmysql node sage-rw/bin/schemabuilder.js
rm -rf $INSTANCE_HOME/loopback/qms/data/filestore
