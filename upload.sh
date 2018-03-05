#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

INFO_FN=".upload_info"
SCRIPT_DIR="$(basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"

if [ -f "${INFO_FN}" ]; then
    source "${INFO_FN}"
else
    HOST="chrisburr.me"
    WEB_BASE="/usr/share/nginx/html"
    URL_SECRET="$(python3.6 -c 'import secrets; print(secrets.token_urlsafe(32))')"
    DIR_NAME="${SCRIPT_DIR}"

    {
        echo "HOST=${HOST}";
        echo "WEB_BASE=${WEB_BASE}";
        echo "URL_SECRET=${URL_SECRET}";
        echo "DIR_NAME=${DIR_NAME}"
    } > "${INFO_FN}"
fi

if [ "${DIR_NAME}" != "${SCRIPT_DIR}" ]; then
    echo "ERROR: Trying to upload ${SCRIPT_DIR} to ${DIR_NAME}"
    exit 2
fi

FS_PATH="${WEB_BASE}/presentations/${URL_SECRET}/${DIR_NAME}/"
URL="https://${HOST}/presentations/${URL_SECRET}/${DIR_NAME}/"

ssh "${HOST}" mkdir -p "${FS_PATH}"
rsync --recursive --progress --delete assets index.html logos markdown.md "${HOST}":"${FS_PATH}"

# Convert to PDF allowing for it to fail at first
decktape remark "${URL}" chris_burr.pdf || (sleep 30 && decktape remark "${URL}" chris_burr.pdf)
rsync --recursive --progress --delete chris_burr.pdf "${HOST}":"${FS_PATH}"

echo
echo "Presentation is now available at: ${URL}"
echo "PDF is now available at: ${URL}chris_burr.pdf"
echo
