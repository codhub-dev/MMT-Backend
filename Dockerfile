# Simple example for a Node.js app
FROM node:12.2.0-alpine

WORKDIR app

COPY ..
RUN npm install
EXPOSE 8000

CMD ["npm", "start"]
