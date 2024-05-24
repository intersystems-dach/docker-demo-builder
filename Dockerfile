ARG IRIS_IMAGE
ARG IRIS_TAG
FROM ${IRIS_IMAGE}:${IRIS_TAG}

COPY --chown="${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP}" ./projects /opt/irisbuild/projects
COPY --chmod=765 ./resources/install_projects.sh /opt/irisbuild/install_projects.sh
RUN iris start IRIS \
    && /opt/irisbuild/install_projects.sh \
    && iris stop IRIS quietly

ARG IRIS_PW
RUN echo "${IRIS_PW}" > /home/irisowner/password.txt \
    && chown "${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP}" /home/irisowner/password.txt \
    && /usr/irissys/dev/Container/changePassword.sh /home/irisowner/password.txt \
    && rm /home/irisowner/password.txt.done
