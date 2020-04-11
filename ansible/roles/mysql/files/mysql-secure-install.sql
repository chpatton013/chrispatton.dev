# Enforce unix_socket authentication for root user.
UPDATE mysql.global_priv
SET priv=json_set(
  priv,
  '$.password_last_changed',
  UNIX_TIMESTAMP(),
  '$.plugin',
  'mysql_native_password',
  '$.authentication_string',
  'invalid',
  '$.auth_or',
  json_array(json_object(), json_object('plugin', 'unix_socket'))
)
WHERE User='root';

# Remove anonymous users.
DELETE FROM mysql.global_priv
WHERE User='';

# Remove remote root login.
DELETE FROM mysql.global_priv
WHERE User='root'
  AND Host NOT IN ('localhost', '127.0.0.1', '::1');

# Remove test database.
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db
WHERE Db='test'
   OR Db='test\\_%';

# Sync privileges so changes take effect.
FLUSH PRIVILEGES;
