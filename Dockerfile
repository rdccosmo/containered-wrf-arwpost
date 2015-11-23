FROM rdccosmo/wps
USER root
RUN apt-get install -y libgrib2c-dev libjpeg-dev libudunits2-dev grads
USER wrf
ENV ARW_CONFIGURE_OPTION 3
ENV CPP /lib/cpp -P 

RUN cd $DIR && wget http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz && \
    tar zxvf ARWpost_V3.tar.gz && rm -rf ARWpost_V3.tar.gz && \
    cd ARWpost && \
    echo $ARW_CONFIGURE_OPTION | ./configure --prefix=$PREFIX && \
    sed -i "s/-ffree-form -O/-ffree-form -O -cpp/" configure.arwp && \
    sed -i "s/-ffixed-form -O/-ffixed-form -O -cpp/" configure.arwp && \
    sed -i "s/-lnetcdf/-lnetcdff -lnetcdf/" src/Makefile && \
    ./compile

