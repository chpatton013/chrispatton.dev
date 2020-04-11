# Create the bookstack database.
CREATE DATABASE IF NOT EXISTS `{{bookstack_db_name}}`;

{% for user_host in bookstack_db_user_hosts %}
# Create user {{bookstack_db_user_name}}@{{user_host}} and grant them privileges on
# the bookstack database.
CREATE USER IF NOT EXISTS '{{bookstack_db_user_name}}'@'{{user_host}}'
IDENTIFIED BY '{{bookstack_db_user_pass}}';

GRANT ALL
ON `{{bookstack_db_name}}`.*
TO '{{bookstack_db_user_name}}'@'{{user_host}}';

{% endfor %}

# Sync privileges so changes take effect.
FLUSH PRIVILEGES;
