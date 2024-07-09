# 1 - Etapa de build

# Indica a imagem a ser trabalhada
FROM golang:1.22.4-alpine as builder

# Indica o diretório atual a ser trabalhado
WORKDIR /app

# Realiza a cópia dos arquivos necessários para a instalação das libs
COPY go.mod go.sum ./

# Executa o comando de instalação das libs
RUN go mod download && go mod verify

# Faz a cópia de todos os arquivos para realizar o build do projeto
COPY . . 

# Indica o diretório atual a ser trabalhado
WORKDIR /app/cmd/journey

# Executa o build, -o especifica o caminho que será armazenado o arquivo de build gerado
RUN go build -o /bin/journey .

# 2 - Etapa de execução

# Permite a execução de uma aplicação de forma mais enxuta
FROM scratch

WORKDIR /app

# Copia o arquivo de build gerado para a execução da aplicação
COPY --from=builder /bin/journey .

EXPOSE 8080

ENTRYPOINT ["./journey"]