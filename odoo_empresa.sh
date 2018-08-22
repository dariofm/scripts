#--------------------------------------------------
# Instalando Servidor Odoo
#--------------------------------------------------
echo -e "\n---- Criando usuário e diretórios para instalação do Servidor Odoo ----"
sudo adduser --system --home=/opt/odoo --group odoo

echo -e "\n---- Criando diretório de Log ----"
mkdir /var/log/odoo
sudo chown -R odoo: /var/log/odoo

echo -e "\n---- Baixando core do Servidor Odoo ----"
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 11.0 --single-branch /opt/odoo/mj_menezes/core
sudo git clone https://github.com/Trust-Code/odoo-brasil.git --depth 1 --branch 11.0 --single-branch /opt/odoo/mj_menezes/modulos/localbr
sudo git clone https://github.com/dariofm/backend.git /opt/odoo/mj_menezes/modulos/backend
echo "\n---- Criando arquivo de configuração do Servidor ADAX ERP ---"
sudo cat <<EOF > /etc/mj_menezes.conf
[options]
addons_path = /opt/odoo/mj_menezes/core/addons,/opt/odoo/mj_menezes/modulos/localbr
admin_passwd = 1q2w3e4r
auto_reload = False
csv_internal_sep = ,
db_host = localhost
db_port = 5432
db_maxconn = 64
db_name = False
#dbfilter = ^%d$
xmlrpc = True
xmlrpc_port = 8888
db_template = template0
db_user = odoo
db_password= 1q2w3e4r
logfile = /var/log/odoo/log
EOF

echo "\n---- Criando arquivo de inicialização do servidor ---"
sudo cat <<EOF > /etc/systemd/system/mj_menezes.service
[Unit]
Description= Servidor Odoo - ADAX Technology
Documentation=http://www.adaxtechnology.com/
Contact=contato@adaxtechnology.com

[Service]
#--------------------------------------------------
# Configurando Cluster
#--------------------------------------------------
sudo -u postgres pg_createcluster 9.5 mj_menezes -p 5001 --start
sudo pg_lsclusters
sudo -u postgres createuser --cluster=9.5/mj_menezes -P -E -s -p 5001 odoo


# Ubuntu:

Type=simple
User=odoo
PIDFile=/var/run/odoo.pid
ExecStart=/opt/odoo/mj_menezes/core/odoo-bin -c /etc/mj_menezes.conf
Restart=on-abort

[Install]
WantedBy=default.target
EOF




sudo chmod a+x /etc/systemd/system/mj_menezes.service

echo -e "\n---- Startando serviço do Servidor Odoo ----"
sudo systemctl enable mj_menezes.service

echo -e "\n---- Ativando serviço do Servidor Odoo no boot ----"
sudo systemctl start mj_menezes.service
sudo service mj_menezes status

