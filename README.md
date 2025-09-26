# bingo-driven
Sistema para a administração de jogos de bingo.

![demonstração do bingo](demo-bingo.gif)

## Funcionalidades
- Criação de jogos de bingo.
- Geração de números para um jogo (sorteio).
- Finalização de jogos.
- Armazenamento dos jogos e seus números sorteados.

## Tecnologias
- Back-end: Node.js, Express, Typescript, Jest e Prisma.
- Banco de dados: Postgres.

## Link
- https://bingo-driven-back-end.onrender.com

## Usando o Docker para rodar todo o projeto manualmente
Os passos para subir manualmente são:
- Implementação do "Dockerfile" na raiz do projeto;

- Realizar o build da imagem:
    $ docker build -t nomedaimagem .

- Criar uma rede para comunicação dos containers:
    $ docker network create nomedarede

- Criar um volume:
    $ docker volume create nomedovolume

- Subir o serviço de banco de dados em um container:
    $ docker run -d --name nomedocontainer --network nomedarede -e POSTGRES_PASSWORD=senhadeescolha -p 5433:5432 postgres

- Subir o back-end em um container:
    $ docker run -d --name nomedocontainer --network nomedarede -p 5000:5000 nomedaimagem

- Subir o front-end em um container:
    $ docker run -d --name nomedocontainer --network nomedarede -p 8000:80 nomedofrontend

## Usando o Docker Compose para rodar somente o back-end
- Faça o build da imagem: docker build -t backend .

O docker compose permite a automatização do processo para rodar o projeto através da criação do arquivo "docker-compose.yml", neste caso, subiremos os serviços do qual o back-end depende e o back-end:

    services:
        <nome do serviço de banco de dados>:
            image: postgres
            container_name: <nome do container>
            ports:
              - 5433:5432 # porta do host e porta padrão do banco de dados do postgres
            networks:
              - <nome da rede>
            environment:
                POSTGRES_USER: postgres
                POSTGRES_PASSWORD: <senha de escolha>
                POSTGRES_DB: <nome do banco de dados>
            volumes:
              - <nome do volume>:/var/lib/postgresql/data
            healthcheck:
                test: ["CMD-SHELL", "pg_isready -q -d alr_db -U postgres"]
                interval: 5s
                timeout: 5s
                retries: 5
        <nome do serviço de back-end>:
            image: backend
            container_name: <nome do container>
            build: backend/
            ports:
              - 5000:5000
            networks:
              - <nome da rede>
            depends_on:
                <nome do serviço de banco de dados>:
                    condition: service_healthy
            DATABASE_URL: "postgresql://postgres:<senha de escolha>@<nome do serviço de banco de dados>:5432/<nome do banco de dados>?schema=public"
     
    networks:
        <nome da rede>:
            name: <nome da rede>

    volumes:
        <nome do volume>:
    
Comandos para rodar o projeto usando o docker compose:
- Subir o projeto:
    $ docker compose up 
- Parar o projeto:
    $ docker compose stop
- Desmontar o projeto:
    $ docker compose down
- Recriar o projeto:
    $ docker compose up --build