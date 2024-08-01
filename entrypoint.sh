#!/bin/sh

missing_vars=false

if [ -z "$CLOUD_SQL_CREDENTIALS_BASE64" ]; then
  echo "CLOUD_SQL_CREDENTIALS_BASE64 environment variable is not set."
  missing_vars=true
fi

if [ -z "$INSTANCE_CONNECTION_NAME" ]; then
  echo "INSTANCE_CONNECTION_NAME environment variable is not set."
  missing_vars=true
fi

if [ "$missing_vars" = true ]; then
  exit 1
fi

CLOUD_SQL_CREDENTIALS_JSON=$(echo "$CLOUD_SQL_CREDENTIALS_BASE64" | base64 -d)

echo "$CLOUD_SQL_CREDENTIALS_JSON" > /tmp/service-account-key.json

exec /cloud-sql-proxy --address 0.0.0.0 --port "$PORT" --credentials-file /tmp/service-account-key.json "$INSTANCE_CONNECTION_NAME" "$@"