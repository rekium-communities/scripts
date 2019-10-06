# This script depends on jq
# Run environmental variables so they are available in the main script
. env.sh

#Due to lack of support from SEAT. This script has to live within the same environment as the db or modify script to do it remotely

SQLRESULT=$(mysql -u${DB_USER} -p${DB_PASSWORD} --database=${DB_USER} -e "select character_id from corporation_member_trackings where corporation_id=98176563 AND character_id not in (select id from users);")
 
CHARRESULT=""
for CHARACTER_ID in ${SQLRESULT}; do

  if [  "$CHARACTER_ID" != "character_id" ]
      then 
      NAME=$(curl -X GET "https://esi.evetech.net/latest/characters/${CHARACTER_ID}/?datasource=tranquility" -H "accept: application/json" | jq '.name' | tr -d '"' )
      CHARRESULT="${CHARRESULT}\n${NAME}"
   fi
done



curl -X POST -H 'Content-Type: application/json' -d '{"chat_id": "-362621306", "text": "Characteres de Rekium no registrados en SEAT:\n'"$CHARRESULT"'"}'  ${TELEGRAM_API_ENPOINT}
