# awslocal events create-event-bus \
#     --name bus-1
# Works on default event bus so this is unneeded

# create cronjob rule that executes every minute
awslocal events put-rule \
    --name "rule-1-minute-cron" \
    --schedule-expression "cron(*/1 * * * ? *)" \
    --event-pattern '{"Source": ["local-machine"]}'

awslocal events create-connection \
    --name "API_Connection" \
    --description "API Connection that receives the event" \
    --authorization-type "API_KEY" \
    --auth-parameters '{ "ApiKeyAuthParameters": { "ApiKeyName": "X-API-KEY", "ApiKeyValue": "api_key" } }'

awslocal events create-api-destination \
    --name "local_example_app_dest" \
    --description "send test event to local test app" \
    --connection-arn "arn:aws:events:us-east-1:000000000000:connection/API_Connection/016481f0-286a-401f-b828-0dc9a3b8bc2f" \
    --invocation-rate-limit-per-second 50  \
    --invocation-endpoint "http://host.docker.internal:3000/" \
    --http-method "POST"

awslocal events put-targets \
    --rule "rule-1-minute-cron" \
    --targets "Id"="local_example_app_dest","Arn"="arn:aws:events:us-east-1:000000000000:api-destination/local_example_app_dest/f0e139e6-c53d-4dd6-b3f2-588512a83606"


awslocal events put-events \
    --entries '[{"DetailType": "jsonRequest", "EventBusName": "default", "Source": "local-machine", "Detail": "{ \"id\": 12345, \"data\": \"wow this worked\" }"}]'




# Commands
awslocal events list-event-buses
awslocal events list-rules
awslocal events list-api-destinations
awslocal events list-targets-by-rule --rule rule-1-minute-cron