#!/usr/bin/env bash

curl --location --insecure --request POST 'https://api.openai.com/v1/chat/completions' \
--header "Authorization: Bearer $OPENAI_API_KEY" \
--header 'Content-Type: application/json' \
--data-raw '{
 "model": "gpt-3.5-turbo",
 "messages": [{"role": "user", "content": "What is the OpenAI mission?"}]
}'
