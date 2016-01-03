# trusty-wp

Implementa Wordpress baseando se na Imagem parana/trusty-php

Assume nome de database `wordpress`, usuário `root` no MySQL 
e as seguintes váriáveis de ambiente para acesso ao database:

Providas pelo Docker:

    MYSQL_PORT_3306_TCP_ADDR
    MYSQL_PORT_3306_TCP_PORT

Providos pelo usuário:

    MYSQL_ROOT_PASSWORD

Criando a imagem:

    echo "# " >> conf/smtp/.GMAILRC

Rodando o contêiner:

    docker run -d -e MYSQL_ROOT_PASSWORD="xpto" \
               --name mysql-server-01 mariadb
    docker logs mysql-server-01
    docker run -i -t --name wp-4.4 --rm \
               --link mysql-server-01:mysql \
               -e MYSQL_ROOT_PASSWORD="xpto" \
               -p 80:80 \
               parana/trusty-wp

Observe que o terminal fica bloqueado na console do Ubuntu 14.04

Para investigar problemas você pode abrir uma nova aba ou janela com um 
Terminal e executar o comando:

    docker exec -i -t wp-4.4 bash  

Com isso você poderá executar comandos tais como:

    cat /var/log/apache2/error.log

