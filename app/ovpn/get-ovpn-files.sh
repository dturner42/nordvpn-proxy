#!/bin/bash

. /app/date.sh --source-only
nordvpn_hostname=$(cat /tmp/nordvpn_hostname)

#Set file name
if [ "${PROTOCOL,,}" = "udp" ]; then
    filename=$nordvpn_hostname${OVPN_UDP}
else
    filename=$nordvpn_hostname${OVPN_TCP}
fi


function download_files {
  # the current ovpn zip file is more than two hours old.
  echo "$(adddate) INFO: Downloading new OVPN file."

  #Create directory if no volume is done
  mkdir -p ${OVPN_CONFIG_DIR}

  #Remove current zip
  rm -rf ${OVPN_CONFIG_DIR}/$filename

  #Curl download ovpn files from NordVPN
  curl -s -o ${OVPN_CONFIG_DIR}/$filename ${OVPN_START}$filename

  #Print out logging
  if [ $? -eq 0 ]; then
      echo "$(adddate) INFO: OVPN files successfully downloaded"
  else
      echo "$(adddate) ERROR: OVPN file download failed!"
  fi
}

# check if the file exists
  if [ -f ${OVPN_CONFIG_DIR}/$filename ]; then
      if test `find ${OVPN_CONFIG_DIR}/$filename -mmin +${REFRESH_TIME}`; then
          download_files
      else
          echo "$(adddate) INFO: Skipping downloading OVPN files - as they are not older than ${REFRESH_TIME} minute(s)."
      fi
  else
      download_files
  fi
