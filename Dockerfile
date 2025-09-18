FROM node:alpine

WORKDIR /usr/src

COPY . .

EXPOSE 5000

RUN npm i && \
    npm run build && \
    apk add --no-cache openssl

CMD ["npm", "start"]