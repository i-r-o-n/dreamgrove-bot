FROM haskell:9.10

WORKDIR /app

RUN apt-get update && \
    apt-get install -y libpq-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p .env

COPY package.yaml stack.yaml stack.yaml.lock ./

RUN stack setup && \
    stack build --only-dependencies

COPY . .

RUN stack build

CMD ["stack", "run"]
