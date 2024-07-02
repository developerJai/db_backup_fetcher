# README

## Login server via SSH, extract database dump and download it to local machine

### Setup Environment variables in .env file

```
SERVER_HOST=your_server_public_domain_or_ip
SERVER_USER=your_server_username
SERVER_PEMFILE=your_pem_file_name_in_config/credentials_directory
SERVER_DATABASE_NAME=server_database_name
SERVER_DATABASE_USER=server_database_username
SERVER_DATABASE_PASS=server_database_password
```

### Put your server .pem file to credentials

You have to put your server pem file to the config/credentials directory in the project.
This location is added in gitignore. This pem file will not pass through git

### Run the rake task:

`rake db:transfer_dump`