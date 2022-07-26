# Docker Image for Laminas API Tools with OAuth2 Support

Docker image for [Laminas API Tools OAuth2](https://github.com/misterabdul/laminas-api-tools-oauth2).

## Example Usage

Inside the project directory, run this command:

```sh
$ docker run -tid --name laminas-api-tools-oauth2 --privileged --link databases_mariadb --network docker-network -v $(pwd):/var/www/dev/api/current -p 8080:80 misterabdul/docker-for-laminas-api-tools-oauth2:rl85-nginx120-php80
```
