# This script on jq
# Run environmental variables so they are available in the main script
. env.sh

#Does request to get characters
PAGES=$(curl -X  GET "https://pilotos.rekium.org/api/v2/users" -H "accept: application/json" -H "X-Token: ${X_TOKEN}" -H "X-CSRF-TOKEN: "  | jq '.meta.last_page') 

INITIAL_PAGE="1"
 
EXPIRED_CHARACTERS=""
while [[ $INITIAL_PAGE -le $PAGES ]]
do
  CHARACTERS=$(curl -X  GET "https://pilotos.rekium.org/api/v2/users?page=${INITIAL_PAGE}" -H "accept: application/json" -H "X-Token: ${X_TOKEN}" -H "X-CSRF-TOKEN: " |  jq '.data[] | select (.token.refresh_token==null) | .name')

  if [ ! -z "$CHARACTERS" -a "$CHARACTERS" != " " ]
      then 
        EXPIRED_CHARACTERS="${EXPIRED_CHARACTERS}\n"
  fi 

  EXPIRED_CHARACTERS="${EXPIRED_CHARACTERS} ${CHARACTERS}" 

  INITIAL_PAGE=$[$INITIAL_PAGE+1]
done

 
EXPIRED_CHARACTERS="${EXPIRED_CHARACTERS//\"}"

curl -X POST -H 'Content-Type: application/json' -d '{"chat_id": "-362621306", "text": "SEAT Characteres con token invalidos:\n'"$EXPIRED_CHARACTERS"'"}'  ${TELEGRAM_API_ENPOINT}
