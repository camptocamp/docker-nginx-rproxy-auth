FROM h3nrik/nginx-ldap
MAINTAINER Raphaël Pinson, raphael.pinson@camptocamp.com

# Configure locales and timezone
#RUN locale-gen en_US.UTF-8 en_GB.UTF-8 fr_CH.UTF-8
#RUN cp /usr/share/zoneinfo/Europe/Zurich /etc/localtime
#RUN echo "Europe/Zurich" > /etc/timezone

# install s6 binaries
COPY bin /usr/bin/
RUN chmod a+x /usr/bin/s6-*

# install configurations
COPY configs/etc /etc/
RUN chmod a+x /etc/s6/.s6-svscan/finish /etc/s6/nginx/run /etc/s6/nginx/finish

# install scripts
COPY scripts/setup.sh /opt/setup.sh
RUN chmod a+x /opt/setup.sh

EXPOSE 80

CMD ["/usr/bin/s6-svscan", "/etc/s6"]
