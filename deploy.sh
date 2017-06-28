#!/bin/bash -e
# build script for sparsehash

. /etc/profile.d/modules.sh
module add deploy
cd ${WORKSPACE}/${NAME}-${NAME}-${VERSION}/build-${BUILD_NUMBER}
rm -rf *
../configure --prefix=${SOFT_DIR}
make install
mkdir -p ${REPO_DIR}
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       SPARSEHASH_VERSION       $VERSION
setenv       SPARSEHASH_DIR                 $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH           $::env(SPARSEHASH_DIR)/lib
prepend-path CFLAGS                              $::env(SPARSEHASH_DIR)/include
MODULE_FILE
) > modules/$VERSION

mkdir -p ${LIBRARIES}/${NAME}
cp modules/$VERSION ${LIBRARIES}/${NAME}

module avail ${NAME}
module add ${NAME}/${VERSION}
