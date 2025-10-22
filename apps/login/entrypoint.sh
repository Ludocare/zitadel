#!/bin/sh

# Generate the Infisical token for authentication
export INFISICAL_TOKEN=$(infisical login --method=universal-auth --client-id=$INFISICAL_MACHINE_CLIENT_ID --client-secret=$INFISICAL_MACHINE_CLIENT_SECRET --plain --silent)

# Run the Next.js application with environment variables injected by Infisical
exec infisical run --token $INFISICAL_TOKEN --projectId $PROJECT_ID --env $INFISICAL_SECRET_ENV --domain $INFISICAL_API_URL -- node server.js