## Caddy configs

This contains a collection of Caddyfiles used for various websites/services. They may be complete, or templates. To actually use them, make sure they are included the caddy-compose.yaml file.

## Adding a new Caddyfile for a new website

Update the `caddy-compose.yaml` file appropriately.

Run the `task web:caddy-reload` task.

This will:

- Send new files to the server.
- Restart the compose service.
