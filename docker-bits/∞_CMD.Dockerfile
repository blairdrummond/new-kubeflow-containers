# Configure container startup
EXPOSE 8888
COPY start-custom.sh /usr/local/bin/
USER jovyan
ENTRYPOINT ["tini", "--"]
CMD ["start-custom.sh"]