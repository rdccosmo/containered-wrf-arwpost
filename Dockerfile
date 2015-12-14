FROM rdccosmo/wps
USER root
RUN apt-get install -y libgrib2c-dev libjpeg-dev libudunits2-dev 
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

RUN cd $DIR && wget ftp://cola.gmu.edu/grads/2.0/grads-2.0.2-src.tar.gz && \
    tar zxvf grads-2.0.2-src.tar.gz && rm -rf grads-2.0.2-src.tar.gz && \
    cd grads-2.0.2 && \
    CPPFLAGS=-I$PREFIX/include LDFLAGS=-L$PREFIX/lib ./configure --with-hdf5 --with-hdf5-include=$PREFIX/include --with-hdf5-libdir=$PREFIX/lib --with-netcdf --with-netcdf-include=$PREFIX/include --with-netcdf-libdir=$PREFIX/lib --with-grib2 --with-grib2-include=$PREFIX/include --with-grib2-libdir=$PREFIX/lib --prefix=$PREFIX

ENV GRADS $DIR/grads-2.0.2.opa.2/Contents
ENV GRADDIR $GRADS/Resources/SupportData
ENV GASCRP $GRADS/Resources/Scripts
ENV PATH $GRADS:$GRADS/gribmap:$PATH

