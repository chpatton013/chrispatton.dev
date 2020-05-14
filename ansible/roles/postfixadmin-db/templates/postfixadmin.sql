# Create the postfixadmin database.
CREATE DATABASE IF NOT EXISTS `{{postfixadmin_db_name}}`;

{% for user_host in postfixadmin_db_user_hosts %}
# Create user {{postfixadmin_db_user_name}}@{{user_host}} and grant them
# privileges on # the postfixadmin database.
CREATE USER IF NOT EXISTS '{{postfixadmin_db_user_name}}'@'{{user_host}}'
IDENTIFIED BY '{{postfixadmin_db_user_pass}}';

GRANT ALL
ON `{{postfixadmin_db_name}}`.*
TO '{{postfixadmin_db_user_name}}'@'{{user_host}}';

{% endfor %}

# Sync privileges so changes take effect.
FLUSH PRIVILEGES;
