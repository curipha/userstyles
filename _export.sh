#!/bin/sh

# Stylish extractor
# * Extract stylish.sqlite to *.user.css files

SQLITE=sqlite3
SQLITEOPTION=-list
STYLISH=stylish.sqlite

USERCSSEXT=.user.css
DISABLEDIR=obsolete

SQLITECMD="${SQLITE} ${SQLITEOPTION} ${STYLISH}"


# Check settings/environments
if [ ! -x "`which ${SQLITE} 2> /dev/null`" ]; then
  echo "ERR: SQLite (${SQLITE}) is not exists."
  exit 1
fi

if [ ! -f ${STYLISH} ]; then
  echo "ERR: Stylish file (${STYLISH}) is not exists."
  exit 1
fi


# Remove current user.css
find . -type f -iname "*${USERCSSEXT}" -exec rm {} \;

# Create disable directory if not exists
if [ ! -e ${DISABLEDIR} ]; then
  mkdir ${DISABLEDIR}
fi


# Extract userstyles from stylish.sqlite
${SQLITECMD} 'select id from styles where url is null order by id' \
  | \
  while read id; do
    NAME=`${SQLITECMD} "select name from styles where id = ${id}"`
    DESC=`echo ${NAME} | perl -pe 's/^(?!\[XUL\])(\[[^\]]+\])\s*(.+)$/\2/g'`

    ENABLED=`${SQLITECMD} "select enabled from styles where id = ${id}"`
    if [ ${ENABLED} = "1" ]; then
      DIR=./
    else
      DIR=./${DISABLEDIR}/
    fi

    BASE=`echo ${DESC} | sed -e 's/ \+/_/g' | tr -cd 'A-Za-z0-9._-'`
    FILE="${DIR}${BASE}${USERCSSEXT}"

    echo Processing "${NAME}"...

    echo "/* ${DESC} */" > ${FILE}
    ${SQLITECMD} "select code from styles where id = ${id}" | tr -d "\r" >> ${FILE}

    chmod 0644 ${FILE}
  done

