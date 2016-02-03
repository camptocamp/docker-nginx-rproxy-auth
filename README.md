Summary
-------

Nginx reverse proxy image with basic authentication. This allow to protect the
access to a web interface. The unsecure service to protect will run on a
protected network that does not allow access from the outside word. The access
to this service from the outside word will onyl be allowed through the proxy
with basic authentication.

This means the unsecure service and the proxy are connected together using docker 
linking system.


Build the image
---------------

To create this image, execute the following command in the docker-nginx-rproxy-auth
folder.

    docker build \
        -t cburki/nginx-rproxy-auth
        .


Configure the image
-------------------

The following environment variables must be set in order to configure the proxy.

    - PROXY_AUTH_USERNAME : The username to access the service.
    - PROXY_AUTH_PASSWORD : The password to access the service.
    - PROXY_SERVER_NAME : The server name nginx will use to route the request.
    - SERVICE_ADDRESS : The IP address or hostname of the service to protect is listening on.
    - SERVICE_PORT : The port the service to protect is listening on.


Run the image
-------------

When you run the image, you will link the service you would like to protect and
specify the environment variables described above. You will also publish the port
you want the proxy to listen on but the exposed port must be 80. This is the one
nginx is listening on inside the container.

    docker run \
        --name nginx-rproxy-auth \
        --link <service_container_name>:<service_alias> \
        -d \
        -e PROXY_AUTH_USERNAME=<username> \
        -e PROXY_AUTH_PASSWORD=<your_secret_password> \
        -e PROXY_SERVER_NAME=<server_name> \
        -e SERVICE_ADDRESS=<service_alias> \
        -e SERVICE_PORT=<service_port> \
        -p <publish_port>:80 \
        cburki/nginx-rproxy-auth:latest
