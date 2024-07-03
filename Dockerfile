ARG IRIS_IMAGE
ARG IRIS_TAG
FROM ${IRIS_IMAGE}:${IRIS_TAG}

COPY --chown="${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP}" ./projects /opt/irisbuild/projects
COPY --chmod=765 ./resources/install_projects.sh /opt/irisbuild/install_projects.sh
RUN iris start IRIS \
    && /opt/irisbuild/install_projects.sh \
    && iris stop IRIS quietly

# This build arg is used to invalidate the cache if the password changed
ARG CACHEBUST
RUN --mount=type=secret,id=iris_pw,mode=0444 /usr/irissys/dev/Container/changePassword.sh /run/secrets/iris_pw
