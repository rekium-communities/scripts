# Run environmental variables so they are available in the main script
. env.sh

# Sets Web Services "Arrays"
WEB_SERVICES="https://pilotos.rekium.org/home"
WEB_SERVICES="${WEB_SERVICES} http://foro.rekium.org"


#Set Other Services "Arrays"
OTHER_SERVICES="ts.rekium.org"

 
#Loops Services and accomulates http results
WEB_RESULT=""
for SERVICES in ${WEB_SERVICES}; do
  WEB_RESULT="${WEB_RESULT}$SERVICES $(curl -sL -w "%{http_code}" -I "${SERVICES}" -o /dev/null)\n"
done

#Loops other services and accomulate ping results
OTHER_RESULTS=""
for SERVICES in ${OTHER_SERVICES}; do
  ping -c1 "${OTHER_SERVICES}" > /dev/null
  if [ $? -eq 0 ]
    then 
     OTHER_RESULTS="${OTHER_SERVICES} Alive" 
    else
     OTHER_RESULTS="${OTHER_SERVICES} DEAD" 
  fi
done


curl -X POST -H 'Content-Type: application/json' -d '{"chat_id": "-362621306", "text": "Chequeo diario de Servicios:\n'"$WEB_RESULT$OTHER_RESULTS"'"}'  ${TELEGRAM_API_ENPOINT}

