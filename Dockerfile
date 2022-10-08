FROM --platform=linux/amd64 alpine:3.15

# Set default variable values
ENV FILE_PREFIX backup
ENV SCHEDULE **None**
ENV HEALTH_CHECK_PORT 80
ENV LOCAL_DIR **None**
ENV LOCAL_KEEP_DAYS **None**
ENV FTP_HOST **None**
ENV FTP_PORT 21
ENV FTP_PATH **None**
ENV FTP_USER **None**
ENV FTP_PASSWORD **None**
ENV NFS_MOUNT_PATH **None**
ENV NFS_MOUNT_OPTIONS ''
ENV NFS_KEEP_DAYS **None**

# Run install
ADD install.sh install.sh
RUN sh install.sh && rm install.sh

# Create backup dir
RUN mkdir /backup

# Add scripts
ADD run.sh run.sh
ADD backup.sh backup.sh
ADD transfer-local.sh transfer-local.sh
ADD transfer-ftp.sh transfer-ftp.sh
ADD transfer-nfs.sh transfer-nfs.sh

# Make backup.sh executable so it can be run manually
RUN chmod +x backup.sh


# Set default variable values
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_DATABASE **None**
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS '--format=c'

# Install
ADD install.sh install.sh
ADD installdb.sh installdb.sh

RUN sh install.sh && rm install.sh
RUN sh installdb.sh && rm installdb.sh

# Add dump.sh script, called by our parent image
ADD dump.sh dump.sh

# Run once or start gp-cron
CMD ["sh", "run.sh"]