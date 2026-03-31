ARG IMAGE_MARIADB_BASE=rodepelomakefile
ARG IMAGE_MARIADB_BASE_VERSION=rodepelomakefile

FROM ${IMAGE_MARIADB_BASE}:${IMAGE_MARIADB_BASE_VERSION} AS builder


#ARG GIT_DB_REF=https://github.com/spbgovbr/sei-db-ref-executivo/raw/feat/master
ARG GIT_DB_REF=https://github.com/spbgovbr/sei-db-ref-executivo/raw/master

############################# INÍCIO DA INSTALAÇÃO #############################
ENV MYSQL_ROOT_PASSWORD=P@ssword

COPY assets/99-sei.cnf /etc/mysql/mariadb.conf.d/
COPY assets/pre-install.sql /docker-entrypoint-initdb.d/1_pre-install.sql
ADD ${GIT_DB_REF}/mysql/v5.0.0/sei_5_0_0_BD_Ref_Exec.sql /docker-entrypoint-initdb.d/2_sei_5_0_0_BD_Ref_Exec.sql
ADD ${GIT_DB_REF}/mysql/v5.0.0/sip_5_0_0_BD_Ref_Exec.sql /docker-entrypoint-initdb.d/3_sip_5_0_0_BD_Ref_Exec.sql
COPY assets/pos-install.sql /docker-entrypoint-initdb.d/9_pos-install.sql

RUN chmod 644 /etc/mysql/mariadb.conf.d/99-sei.cnf
RUN chmod +r /docker-entrypoint-initdb.d/2_sei_5_0_0_BD_Ref_Exec.sql
RUN chmod +r /docker-entrypoint-initdb.d/3_sip_5_0_0_BD_Ref_Exec.sql
RUN sed -i '1i use sei; \n' /docker-entrypoint-initdb.d/2_sei_5_0_0_BD_Ref_Exec.sql
RUN sed -i '1i use sip; \n' /docker-entrypoint-initdb.d/3_sip_5_0_0_BD_Ref_Exec.sql

RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]
RUN ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--datadir", "/initialized-db"]


############################## FIM DA INSTALAÇÃO ###########################
FROM ${IMAGE_MARIADB_BASE}:${IMAGE_MARIADB_BASE_VERSION}
COPY --from=builder /initialized-db /var/lib/mysql
COPY --from=builder /etc/mysql/mariadb.conf.d/99-sei.cnf /etc/mysql/mariadb.conf.d/
