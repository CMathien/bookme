# bookme
Book management app

## Authors

- [@cmathien](https://www.github.com/cmathien)

## API - Project setup
### Docker and SSL certificate

- Copy `.env.dist` file to `.env` and define values
- Launch stack with `docker compose up`
- Install `ssl/bookmeCA.pem` certificate:
  - In Chrome, go to `Settings > Privacy and security > Security > Manage certificates` (it should open a Mac or Windows app)
  - On Mac, you can simply double-clic on `infra/nginx/ssl/bookmeCA.pem`
- Add entry to your OS `hosts` file:
  - `/etc/hosts` on Mac and Linux (edit with sudo)
  - `C:\Windows\System32\driver\etc\hosts` on Windows (edit as admin)
  - `127.0.0.1  api.bookme.local.com`
- API is live at https://api.bookme.local.com

- Run `docker exec -i -w /bookme/api bookme-php-1 composer install`

### QA

> Note: on Windows command must be run in a Powershell terminal not in bash
- Run `docker exec -i -w /bookme/qa bookme-php-1 composer install`

## Commit
- Use the bash terminal in the container `docker exec -it bookme-php-1 sh` and commit in it `git commit -m "replace with your message"`

## Unit tests on API
-Install test database `doc\db\script_test_db.sql` and install your api key in api_key table
-Run `docker exec -i -w /bookme/api bookme-php-1 php vendor/bin/phpunit tests --verbose`

## Ionic
- Run `docker exec -it bookme-app-1 ionic serve --external --public-host=app.bookme.local.com --no-open --ssl`