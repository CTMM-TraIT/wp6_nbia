#!/bin/sh
##
# Patch nbia-web module and update compiled classes in nbia.war and nbia.ear webservice archives. 
#
# First unzip the nbia.ear and nbia.war archvies into the 'nbia-web' module and run this scripts. 
# 

print()
{
   echo "INFO:$@"
}

assert_fileexists()
{
   file=$1; 
   if [ -f "$file" ] ; then 
      return ; 
   fi
  
   print "***Error: File ${file}  does not exists!"
   exit 1; 
}

assert_direxists()
{
   dir=$1; 
   if [ -d "$dir" ] ; then 
      return ; 
   fi
  
   print "***Error: Directory ${dir}  does not exists!"
   exit 1; 
}

###

SOURCE=~/workspace.nbia/bmia_surfconext/currentServer/software/
NBIA_WAR=nbia.war 
NBIA_EAR=nbia.ear
PUB_DIR=~/pub

###

ROOT=`pwd`
print "Starting from:${ROOT}" 

##
## unzip nbia.war into nbia.war directory 
##
# mkdir -p nbia.war 
# cd nbia.war
# unzip ${SOURCE}/target/dist/exploded/nbia-ear/nbia.war 
#

##
## unzip nbia.ear into nbia.war directory 
##
# mkdir -p nbia.ear 
# cd nbia.ear
# unzip ${SOURCE}/target/dist/exploded/nbia-ear/nbia.ear 
#

assert_direxists ${NBIA_WAR} 
assert_direxists ${NBIA_EAR} 

cd ${NBIA_WAR} 
print "PWD="`pwd`

assert_direxists WEB-INF/classes/gov/
assert_direxists images/
assert_direxists WEB-INF/facelets/

rm -rf WEB-INF/classes/gov/*
cp -rvf ${SOURCE}/nbia-web/bin/gov/ WEB-INF/classes/
cp -rvf ${SOURCE}/nbia-web/webapp/images/* images/
cp -rvf ${SOURCE}/nbia-web/webapp/WEB-INF/facelets/* WEB-INF/facelets/

rm -vf ../nbia-sp.war
zip -r ../nbia-sp.war * 
cd ..

assert_direxists ${PUB_DIR}
assert_fileexists nbia-sp.war
assert_direxists nbia.ear

cp nbia-sp.war nbia.ear/nbia.war
cd nbia.ear
rm -vf ../nbia-sp.ear
zip -r ../nbia-sp.ear * 

cd ..
assert_fileexists nbia-sp.ear
cp nbia-sp.ear ${PUB_DIR}

echo "done: see ${PUB_DIR}/" 

