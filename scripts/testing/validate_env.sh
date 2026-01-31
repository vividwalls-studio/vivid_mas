#!/bin/bash

# Validate .env file completeness
echo "🔍 Validating .env file..."

if [[ ! -f ".env" ]]; then
    echo "❌ .env file not found"
    exit 1
fi

source .env

# Check critical variables
critical_vars=(
    "ADMIN_EMAIL"
    "N8N_PASSWORD"
    "SUPABASE_PASSWORD"
    "TWENTY_PASSWORD"
    "MEDUSA_PASSWORD"
    "JWT_SECRET"
    "N8N_ENCRYPTION_KEY"
)

missing_vars=()

for var in "${critical_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -eq 0 ]]; then
    echo "✅ All critical environment variables are set"
    echo "📊 Total variables: $(grep -c "=" .env)"
    echo "🔐 Admin email: $ADMIN_EMAIL"
    echo "🔑 Passwords generated for all services"
else
    echo "❌ Missing critical variables:"
    printf '%s\n' "${missing_vars[@]}"
    exit 1
fi
