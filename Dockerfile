FROM scratch
ADD dsdp /
EXPOSE 53/udp
CMD ["/dsdp"]
