#!/usr/bin/env zsh

if [[ $1 == "-f" ]]; then
  bat --paging=never $2
  INPUT=$(cat $2 | jq -Rsa '.')
else
  echo -e "$@" | bat --paging=never --style=grid
  INPUT=$(echo "$@" | jq -Rsa '.')
fi


JSON='{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant."
    },
    {
      "role": "system",
      "content": "For every answer, you must give authoritative sources."
    },
    {
      "role": "user",
      "content": '"$INPUT"'
    }
  ]
}'
JSON=$(echo -E $JSON | jq)

RES=$(curl https://api.openai.com/v1/chat/completions -s -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API_KEY" -d $JSON)
RES=$(echo -E $RES | jq '.choices[0].message.content' | sed 's/^"//; s/"$//')

print "$RES" | bat --paging=never --style=grid -l md
