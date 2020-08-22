FROM node:14.8.0-alpine3.11

COPY . /app

WORKDIR /app

RUN npm install

ENTRYPOINT ["npm", "start"]
