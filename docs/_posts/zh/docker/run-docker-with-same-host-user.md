# 如何使用主机当前用户运行 docker

这里提供两种方法：

## Method 1: Using --user Flag

Get Current User's UID and GID:
You need to retrieve your current user's UID (User ID) and GID (Group ID). You can do this with the following commands:

```bash
export UID=$(id -u)
export GID=$(id -g)
```

Run Docker Container:
Use the --user flag to specify the UID and GID when running your Docker container. Here’s an example command:

```bash
docker run -it --rm --user $UID:$GID -v "$(pwd):/home/user" <IMAGE_NAME>
```

Replace <IMAGE_NAME> with the name of the Docker image you want to run. This command mounts your current directory into the container and runs it as your user.


## Method 2: Using a Custom Dockerfile

If you frequently need containers running as a specific user, consider creating a custom Docker image:
Create a Dockerfile:
Include the following lines in your Dockerfile to accept UID and GID as build arguments:

``` text
FROM ubuntu

ARG UID
ARG GID

RUN groupadd --gid $GID nonroot && \
    useradd --uid $UID --gid $GID --create-home nonroot && \
    echo 'nonroot ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER nonroot
WORKDIR /home/nonroot
```

Build the Image:
Build the image while passing your host's UID and GID:

```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t your-image-name .
```

Run Your Container:
Run the container using your custom image:

```bash
docker run -it --rm your-image-name
```

This method creates a user inside the container that matches your host's user, ensuring consistent permissions across both environments.

## 参考

- [Set current host user for docker container](https://faun.pub/set-current-host-user-for-docker-container-4e521cef9ffc)