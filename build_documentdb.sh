sudo apt install git build-essential libicu-dev flex bison pkg-config libreadline-dev zlib1g-dev libssl-dev libipc-run-perl curl cmake autoconf libtool libxml2-dev libgeos-dev libproj-dev

export USER_HOME="$HOME"
export INSTALL_DEPENDENCIES_ROOT=$USER_HOME/documentdb-deps
export PGVERSION=17
export MAKE_PROGRAM=cmake

mkdir -p $INSTALL_DEPENDENCIES_ROOT
mkdir -p $USER_HOME/pgsql17
cd ~
git clone https://github.com/documentdb/documentdb.git
cd ~/documentdb/scripts

./install_setup_postgres.sh -v 17 -d $USER_HOME/pgsql17
export PG_CONFIG=$USER_HOME/pgsql17/bin/pg_config
export PATH=$USER_HOME/pgsql17/bin:$PATH

#small modifications to the scripts
sed -i '/function GetPostgresPath()/,/^}/c\
function GetPostgresPath()\
{\
  echo "$USER_HOME/pgsql17/bin"\
}' utils.sh

sed -i '16,25c\scriptDir="$USER_HOME/documentdb/scripts"' install_setup_postgis.sh
sed -i 's/citusVersion=$1/citusVersion=CITUS_13_VERSION/' install_setup_citus_core_oss.sh

#run scripts
sudo -E ./install_setup_pcre2.sh
sudo -E ./install_setup_libbson.sh
sudo -E ./install_setup_intel_decimal_math_lib.sh
sudo -E ./install_setup_pgvector.sh
./install_setup_rum_oss.sh
./install_setup_pg_cron.sh
sudo -E ./install_setup_postgis.sh
sudo -E ./install_setup_citus_core_oss.sh
sudo -E ./install_setup_system_rows.sh

cd $USER_HOME/documentdb
make
make install