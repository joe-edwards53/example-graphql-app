# Works on default event bus so this is unneeded
# awslocal events create-event-bus \
#     --name bus-1

# create cronjob rule that executes every minute
awslocal events put-rule \
    --name "rule-1-minute-cron" \
    --schedule-expression "cron(* * * * ? *)" \
    --event-pattern '{"Source": ["local-machine"]}'

# Creates connection to API specifying details for authorization
awslocal events create-connection \
    --name "API_Connection" \
    --description "API Connection that receives the event" \
    --authorization-type "API_KEY" \
    --auth-parameters '{ "ApiKeyAuthParameters": { "ApiKeyName": "X-API-KEY", "ApiKeyValue": "api_key" } }'

# Creates API Destination in which the event is routed to the targeted API
awslocal events create-api-destination \
    --name "local_example_app_dest" \
    --description "send test event to local test app" \
    --connection-arn "arn:aws:events:us-east-1:000000000000:connection/API_Connection/d2053c71-2b0b-455e-89f1-1a33acccaf2e" \
    --invocation-rate-limit-per-second 50  \
    --invocation-endpoint "http://host.docker.internal:3000/" \
    --http-method "POST"

# Puts the targeted API destination on the rule that events will be sent to
awslocal events put-targets \
    --rule rule-1-minute-cron \
    --targets "Id"="local_example_app_dest","Arn"="arn:aws:events:us-east-1:000000000000:api-destination/local_example_app_dest/9d6e19e7-2586-40d4-9872-19de376943ff"

# Creates a event and sends it
awslocal events put-events \
    --entries '[{"DetailType": "jsonRequest", "EventBusName": "default", "Source": "local-machine", "Detail": "{ \"id\": 12345, \"data\": \"wow this worked\" }"}]'

awslocal lambda create-function --function-name consumer-lambda \
--zip-file fileb://build/notifications-consumer-lambda-development.zip \
--handler index.handler --runtime nodejs16.x \
--role arn:aws:iam::000000000000:role/lambda-role 

# Commands
# awslocal events list-event-buses
# awslocal events list-rules
# awslocal events list-api-destinations
# awslocal events list-targets-by-rule --rule rule-1-minute-cron