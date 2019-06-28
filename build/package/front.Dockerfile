# syntax=docker/dockerfile:experimental

FROM node:11.13.0-alpine as base_builder

# create destination directory
WORKDIR /workspace

# update and install dependency
RUN --mount=type=cache,target=/var/cache/apk \
    apk update \
    && apk add git

# copy the app, note .dockerignore
COPY package.json ./
COPY yarn.lock ./
RUN yarn

# build necessary, even if no static files are needed,
# since it builds the server as well
COPY . .
RUN yarn build

FROM node:11.13.0-alpine

WORKDIR /opt/front

# Fetch deps
COPY --from=base_builder \
     /workspace/package.json \
     /workspace/yarn.lock \
     /opt/front/

# Refetch only prod deps
RUN yarn --production

# Fetch application
COPY --from=base_builder \
     /workspace/.nuxt/ \
     /opt/front/.nuxt

# expose 5000 on container
EXPOSE 5000

# start the app
CMD [ "yarn", "start" ]
