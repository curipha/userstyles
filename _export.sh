#!/usr/bin/env bash

# Stylish extractor
# * Extract stylish.sqlite to *.user.css files

set -o nounset
set -o errexit

FXPROFILE="${USERPROFILE//\\/\/}/AppData/Roaming/Mozilla/Firefox/Profiles"
STYLISH_LIST=list.tmp

SQLITE=sqlite3
SQLITEOPTION=-list
STYLISH=stylish.sqlite

USERCSSEXT=.user.css
DISABLEDIR=obsolete

SQLITECMD="${SQLITE} ${SQLITEOPTION} ${STYLISH}"

abort()
{
  echo $@
  exit 1
}


# Check settings/environments
[[ ! -x "`which ${SQLITE} 2> /dev/null`" ]] && abort "ERR: SQLite (${SQLITE}) is not exists."


# Change directory to the same level as this script
cd `dirname "${0}"`


# Get stylish.sqlite from Firefox's user profile directory
[[ -e "${STYLISH_LIST}" ]] && rm -f "${STYLISH_LIST}"

find "${FXPROFILE}" -type f -iname "${STYLISH}" -fprint "${STYLISH_LIST}"

if [[ ! -s "${STYLISH_LIST}" ]]; then
  rm -f "${STYLISH_LIST}"

  abort "ERR: Cannot find ${STYLISH} from your Firefox profile directory."
fi


# Remove current user.css
find . -name "${DISABLEDIR}" -prune -o -type f -iname "*${USERCSSEXT}" -print0 | xargs -0 rm -f

# Create disable directory if not exists
[[ ! -d "${DISABLEDIR}" ]] && mkdir -vp "${DISABLEDIR}"


# Execute each stylish.sqlite
cat "${STYLISH_LIST}" \
  | \
  while read file; do

    echo Opening "${file}"...

    # Remove older stylish.sqlite
    [[ -e "${STYLISH}" ]] && rm -fv "${STYLISH}"

    # Copy stylish.sqlite
    cp "${file}" "${STYLISH}"

    # Extract userstyles from stylish.sqlite
    ${SQLITECMD} 'select id from styles where url is null order by id' \
      | \
      while read id; do
        NAME=`${SQLITECMD} "select name from styles where id = ${id}"`
        DESC=`echo "${NAME}" | perl -pe 's/^(?!\[XUL\])(\[[^\]]+\])\s*(.+)$/\2/g'`

        ENABLED=`${SQLITECMD} "select enabled from styles where id = ${id}"`
        if [[ "${ENABLED}" = "1" ]]; then
          DIR=./
        else
          DIR="./${DISABLEDIR}/"
        fi

        BASE=`echo "${DESC}" | sed -e 's/ \+/_/g' | tr -cd 'A-Za-z0-9._-'`
        FILE="${DIR}${BASE}${USERCSSEXT}"

        echo Processing "${NAME}"...

        echo "/* ${DESC} */" > "${FILE}"
        ${SQLITECMD} "select code from styles where id = ${id}" | tr -d "\r" | sed -e 's/ \+$//' >> "${FILE}"

        chmod 0644 "${FILE}"
      done

done

# Remove temporary file
[[ -e "${STYLISH}" ]]      && rm -f "${STYLISH}"
[[ -e "${STYLISH_LIST}" ]] && rm -f "${STYLISH_LIST}"

