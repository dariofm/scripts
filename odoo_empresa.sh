
#--------------------------------------------------
# Instalando Servidor Odoo
#--------------------------------------------------
echo -e "\n---- Criando usuário e diretórios para instalação do Servidor Odoo ----"
sudo adduser --system --home=/opt/odoo --group odoo

echo -e "\n---- Criando diretório de Log ----"
mkdir /var/log/odoo
sudo chown -R odoo: /var/log/odoo

echo -e "\n---- Baixando core do Servidor Odoo ----"
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 11.0 --single-branch /opt/odoo/core
sudo git clone https://github.com/Trust-Code/odoo-brasil.git --depth 1 --branch 11.0 --single-branch /opt/odoo/modulos/localbr
##sudo git clone https://github.com/adax-technology/addons-adax.git --branch 11.0 /opt/odoo/modulos/backend
echo "\n---- Criando arquivo de configuração do Servidor ADAX ERP ---"
sudo cat <<EOF > /etc/odoo.conf
[options]
addons_path = /opt/odoo/core/addons,/opt/odoo/modulos/localbr
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
sudo cat <<EOF > /etc/systemd/system/odoo.service
[Unit]
Description= Servidor Odoo - ADAX Technology
Documentation=http://www.adaxtechnology.com/
Contact=contato@adaxtechnology.com

[Service]

# Ubuntu:

Type=simple
User=odoo
PIDFile=/var/run/odoo.pid
ExecStart=/opt/odoo/core/odoo-bin -c /etc/odoo.conf
Restart=on-abort

[Install]
WantedBy=default.target
EOF

sudo chmod a+x /etc/systemd/system/odoo.service

echo -e "\n---- Startando serviço do Servidor Odoo ----"
sudo systemctl enable odoo.service

echo -e "\n---- Ativando serviço do Servidor Odoo no boot ----"
sudo systemctl start odoo.service
sudo service odoo status

