#!/bin/bash
source $(dirname $0)/__functions.sh
HOST_DIR_NAME=$1

#Install packages here
sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get update

 sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo rm /etc/apt/keyrings/docker.gpg

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
sudo usermod -aG docker ubuntu
sudo systemctl unmask docker
sudo systemctl enable docker
sudo systemctl start docker
group=docker

if [ $(id -gn) != $group ]; then
  exec sg $group "$0 $*"
fi

docker-compose -f ${HOST_DIR_NAME}/config/docker-compose.yml down && docker-compose -f ${HOST_DIR_NAME}/config/docker-compose.yml rm -f && docker-compose -f ${HOST_DIR_NAME}/config/docker-compose.yml up -d

sudo tee /etc/update-motd.d/99-manzolo > /dev/null <<-EOF
#!/bin/bash
echo ""
echo ""
echo "$(tput setaf 1)------------------- MANZOLO MARIA DB MANAGER ----------------------------$(tput sgr0)"
echo ""
echo "$(tput setaf 3)#MariaDB shell:$(tput sgr0)"
echo ""
echo "$(tput setaf 2)docker exec -it $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS" $(tput sgr0)"
echo ""
echo "$(tput setaf 3)#Examples:$(tput sgr0)"
echo ""
echo "$(tput setaf 3)#Show databases:$(tput sgr0)"
echo "$(tput setaf 2)docker exec -it $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS" -e \"show databases;\"$(tput sgr0)"
echo ""
echo "$(tput setaf 3)#Create database:$(tput sgr0)"
echo "$(tput setaf 2)docker exec -it $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS" -e \"CREATE DATABASE DATABASE_NAME;\"$(tput sgr0)"
echo ""

echo "$(tput setaf 3)#Create user:$(tput sgr0)"
echo ""
echo docker exec -i $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS -e 'CREATE OR REPLACE USER USERNAME@localhost IDENTIFIED BY \"PASSWORD\" ;'"
echo docker exec -i $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS -e 'CREATE OR REPLACE USER USERNAME@% IDENTIFIED BY \"PASSWORD\" ;'"
echo docker exec -i $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS -e 'GRANT ALL PRIVILEGES ON DATABASE_NAME.* TO 'USERNAME'@localhost;'"
echo docker exec -i $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS -e 'GRANT ALL PRIVILEGES ON DATABASE_NAME.* TO 'USERNAME'@%;'"
echo docker exec -i $DB_CONTAINER_NAME "mysql -uroot -p$DB_ROOT_PASS -e 'FLUSH PRIVILEGES;'"

echo "$(tput setaf 1)-------------------------------------------------------------------------$(tput sgr0)"
EOF

sudo chmod a+x /etc/update-motd.d/99-manzolo


CREATE_USER_CMD="CREATE OR REPLACE USER $DB_USER@\"%\" IDENTIFIED BY \"$DB_PASS\" ;"
MYSQL_CMD="mysql -uroot -p$DB_ROOT_PASS -e '$CREATE_USER_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"
