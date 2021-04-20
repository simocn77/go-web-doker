# The official image for Go as the base image.
#  This image comes with Go 1.15 pre-installed.
#FROM golang:1.15.7-buster
FROM golang:latest

# Installs the bee tool globally (Docker commands run as root by default),
#  which will be used to live-reload our code during development.
RUN go get -u github.com/beego/bee

# Configure the environment variables for Go
ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

# ARG: take effect at build time, we must set these values when we create the image.
# ENV: run-time variables, these are activated when the container is started.
ENV APP_USER app
ENV APP_HOME /go/src/mathapp
ARG GROUP_ID
ARG USER_ID

# Creates a user called app,
#         a home directory
#     and an app directory inside the container
RUN groupadd --gid $GROUP_ID app && useradd -m -l --uid $USER_ID --gid $GROUP_ID $APP_USER
RUN mkdir -p $APP_HOME && chown -R $APP_USER:$APP_USER $APP_HOME
USER $APP_USER
WORKDIR $APP_HOME

# Tells Docker that port 8010 is interesting
EXPOSE 8010

# Uses the bee command to start our application.
CMD ["bee", "run"]
