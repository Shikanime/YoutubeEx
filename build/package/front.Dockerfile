FROM node:10.16.0 as base_builder

# create destination directory
WORKDIR /workspace

# update and install dependency
RUN apt update \
    && apt install -y git

# copy the app, note .dockerignore
COPY package.json ./
COPY yarn.lock ./
RUN yarn

# build necessary, even if no static files are needed,
# since it builds the server as well
COPY . .
RUN yarn build

FROM node:10.16.0

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
