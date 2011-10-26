#!/bin/sh

if [ "$1x" = "x" ]; then
	echo Usage: $0 '<tag/hash/branch>'
	exit= 0
else
	VERSION=$1
fi

PWD=`pwd`
PWD2=${PWD}
TEMPDIR=`mktemp -d`
CLOOG_SRC="${VERSION}"
TARFILE="${VERSION}.tgz"

cd ${TEMPDIR}
if git clone http://repo.or.cz/r/cloog.git ${CLOOG_SRC} ; then
	echo :: Cloning CLooG was successful
else
	echo :: Cloning CLooG failed
	exit 1
fi

cd ${CLOOG_SRC}
if git checkout ${VERSION} ; then
	echo ":: Checking out CLooG at version '${VERSION}' was successful"
else
	echo ":: Checking out CLooG at version '${VERSION}' failed"
	exit 1
fi

if ./get_submodules.sh ; then
	echo ":: Getting submodules successful"
else
	echo ":: Getting submodules failed"
	exit 1
fi
./autogen.sh
rm -rf .git && rm -rf isl/.git

cd ${TEMPDIR}

echo CLOOG_SRC: ${CLOOG_SRC}

if tar -czf ${TARFILE} ${CLOOG_SRC} ; then
	echo :: Tarball successfully created at ${TARFILE}
else
	echo :: Could not create tar file
	exit 1
fi

cp ${TARFILE} ${PWD2}
