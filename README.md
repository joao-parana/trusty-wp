# trusty-wp

Implementa Wordpress baseando se na Imagem parana/trusty-php

Assume nome de database `wordpress`, usuário `root` no MySQL 
e as seguintes váriáveis de ambiente para acesso ao database:

Providas pelo Docker:

    MYSQL_PORT_3306_TCP_ADDR
    MYSQL_PORT_3306_TCP_PORT

Providos pelo usuário:

    MYSQL_ROOT_PASSWORD

Rodando o contêiner:

    docker run -i -t --name wp-4.4 --rm \
               --link some-mysql-server:mysql \
               -e MYSQL_ROOT_PASSWORD="xpto" \
               -p 80:80 \
               parana/trusty-wp
