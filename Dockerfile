FROM ethereum/client-go:stable

WORKDIR /app

COPY genesis.json .
COPY entrypoint.sh .
COPY pass.txt .
COPY keystore ./keystore

RUN chmod +x entrypoint.sh

EXPOSE 8545
EXPOSE 8546

ENTRYPOINT ["./entrypoint.sh"]
