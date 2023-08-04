FROM greyltc/archlinux-aur:paru

# replace "exit $E_ROOT" with "#exit $E_ROOT" in /usr/bin/makepkg
RUN sed -i 's/exit $E_ROOT/#exit $E_ROOT/g' /usr/bin/makepkg

COPY ./iso /root/iso

RUN /root/iso/prep.sh

ENTRYPOINT ["/bin/bash", "/root/iso/build.sh"]