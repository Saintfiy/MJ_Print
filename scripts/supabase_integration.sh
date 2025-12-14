#!/usr/bin/env bash
set -euo pipefail

# Required env vars: SUPABASE_URL, SUPABASE_ANON_KEY, TEST_USER_EMAIL, TEST_USER_PASSWORD
if [[ -z "${SUPABASE_URL:-}" || -z "${SUPABASE_ANON_KEY:-}" || -z "${TEST_USER_EMAIL:-}" || -z "${TEST_USER_PASSWORD:-}" ]]; then
  echo "Missing required environment variables. Please set SUPABASE_URL, SUPABASE_ANON_KEY, TEST_USER_EMAIL, TEST_USER_PASSWORD"
  exit 2
fi

# Helper to parse JSON using python (safe fallback if jq not available)
json_extract() {
  local key=$1
  python3 - <<PY
import sys, json
obj = json.load(sys.stdin)
val = None
for k in "$key".split('.'):
    if obj is None: break
    obj = obj.get(k) if isinstance(obj, dict) else None
print('' if obj is None else obj)
PY
}

echo "Signing in user ${TEST_USER_EMAIL}..."
RESP=$(curl -s -X POST "${SUPABASE_URL}/auth/v1/token" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "email=${TEST_USER_EMAIL}" \
  --data-urlencode "password=${TEST_USER_PASSWORD}")

ACCESS_TOKEN=$(echo "$RESP" | python3 -c "import sys,json; obj=json.load(sys.stdin); print(obj.get('access_token',''))")
USER_ID=$(echo "$RESP" | python3 -c "import sys,json; obj=json.load(sys.stdin); u=obj.get('user'); print(u.get('id') if isinstance(u, dict) else '')")

if [[ -n "$ACCESS_TOKEN" && -n "$USER_ID" ]]; then
  echo "Signed in as user id: $USER_ID"
  AUTH_MODE="user"
else
  echo "Sign-in failed or not available; will use service role key for admin operations if provided."
  AUTH_MODE="service"
fi

# Determine headers to use for subsequent requests
if [[ "$AUTH_MODE" == "service" ]]; then
  if [[ -z "${SUPABASE_SERVICE_ROLE_KEY:-}" ]]; then
    echo "No SUPABASE_SERVICE_ROLE_KEY provided; cannot proceed with admin flow." >&2
    exit 4
  fi
  echo "Fetching profile by email using service role key..."
  PROFILE=$(curl -s -X GET "${SUPABASE_URL}/rest/v1/profiles?select=*&email=eq.${TEST_USER_EMAIL}" \
    -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}")
  USER_ID=$(echo "$PROFILE" | python3 -c "import sys,json; a=json.load(sys.stdin); print(a[0].get('id') if a else '')")
  if [[ -z "$USER_ID" ]]; then
    echo "Profile not found in 'profiles' table; trying admin users endpoint..."
    ADMIN_USERS=$(curl -s -X GET "${SUPABASE_URL}/auth/v1/admin/users?email=${TEST_USER_EMAIL}" \
      -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
      -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}")
    USER_ID=$(echo "$ADMIN_USERS" | python3 - <<PY
import sys,json
d=json.load(sys.stdin)
uid=''
if isinstance(d, list):
    if d:
        uid = d[0].get('id','')
elif isinstance(d, dict):
    if 'users' in d and isinstance(d['users'], list) and d['users']:
        uid = d['users'][0].get('id','')
    elif 'data' in d and isinstance(d['data'], list) and d['data']:
        uid = d['data'][0].get('id','')
    elif 'id' in d:
        uid = d.get('id','')
print(uid)
PY
)
    if [[ -z "$USER_ID" ]]; then
      echo "Could not find user for email ${TEST_USER_EMAIL} via admin endpoint. Ensure the user exists." >&2
      exit 5
    fi
  fi
  echo "Found profile/user id: $USER_ID"
  # Use service role key for api calls
  API_KEY_HEADER="${SUPABASE_SERVICE_ROLE_KEY}"
  AUTH_BEARER="${SUPABASE_SERVICE_ROLE_KEY}"
else
  API_KEY_HEADER="${SUPABASE_ANON_KEY}"
  AUTH_BEARER="${ACCESS_TOKEN}"
fi

# Pick a product (active)
# Use anon key to fetch active product (public policy allows this)
PROD=$(curl -s -X GET "${SUPABASE_URL}/rest/v1/products?select=id,name,price&is_active=eq.true&limit=1" \
  -H "apikey: ${API_KEY_HEADER}")
PRODUCT_ID=$(echo "$PROD" | python3 -c "import sys,json; a=json.load(sys.stdin); print(a[0].get('id') if a else '')")
PRODUCT_NAME=$(echo "$PROD" | python3 -c "import sys,json; a=json.load(sys.stdin); print(a[0].get('name') if a else '')")
PRODUCT_PRICE=$(echo "$PROD" | python3 -c "import sys,json; a=json.load(sys.stdin); print(a[0].get('price') if a else '')")

if [[ -z "$PRODUCT_ID" ]]; then
  echo "No active product found; aborting. Please create a product first." >&2
  exit 6
fi

echo "Using product: $PRODUCT_NAME ($PRODUCT_ID) price $PRODUCT_PRICE"

# Create an order
TOTAL=$(printf "%.2f" "$PRODUCT_PRICE")
FINAL=$TOTAL
ORDER_PAYLOAD=$(cat <<JSON
{
  "user_id": "${USER_ID}",
  "customer_name": "Test Customer",
  "customer_email": "${TEST_USER_EMAIL}",
  "customer_phone": "081234567890",
  "customer_address": "Jl Test No 1",
  "total_amount": ${TOTAL},
  "final_amount": ${FINAL},
  "status": "pending",
  "payment_method": "cash",
  "payment_status": "unpaid",
  "notes": "Integration test order"
}
JSON
)

echo "Inserting order..."
ORDER_RESP=$(curl -s -w "\n%{http_code}" -X POST "${SUPABASE_URL}/rest/v1/orders" \
  -H "apikey: ${API_KEY_HEADER}" \
  -H "Authorization: Bearer ${AUTH_BEARER}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d "$ORDER_PAYLOAD")

HTTP_CODE=$(echo "$ORDER_RESP" | tail -n1)
ORDER_BODY=$(echo "$ORDER_RESP" | sed '$d')

if [[ "$HTTP_CODE" != "201" ]]; then
  echo "Failed to insert order; HTTP $HTTP_CODE" >&2
  echo "$ORDER_BODY" >&2
  exit 5
fi

ORDER_ID=$(echo "$ORDER_BODY" | python3 -c "import sys,json; a=json.load(sys.stdin); print(a[0].get('id',''))")
ORDER_NUMBER=$(echo "$ORDER_BODY" | python3 -c "import sys,json; a=json.load(sys.stdin); print(a[0].get('order_number',''))")

if [[ -z "$ORDER_ID" || -z "$ORDER_NUMBER" ]]; then
  echo "Order insert response missing id/order_number" >&2
  echo "$ORDER_BODY" >&2
  exit 6
fi

echo "Inserted order id: $ORDER_ID order_number: $ORDER_NUMBER"

# Insert order item
ITEM_PAYLOAD=$(cat <<JSON
{
  "order_id": "${ORDER_ID}",
  "product_id": "${PRODUCT_ID}",
  "product_name": "${PRODUCT_NAME}",
  "quantity": 1,
  "unit_price": ${PRODUCT_PRICE},
  "subtotal": ${PRODUCT_PRICE}
}
JSON
)

ITEM_RESP=$(curl -s -w "\n%{http_code}" -X POST "${SUPABASE_URL}/rest/v1/order_items" \
  -H "apikey: ${API_KEY_HEADER}" \
  -H "Authorization: Bearer ${AUTH_BEARER}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d "$ITEM_PAYLOAD")

ITEM_CODE=$(echo "$ITEM_RESP" | tail -n1)
ITEM_BODY=$(echo "$ITEM_RESP" | sed '$d')

if [[ "$ITEM_CODE" != "201" ]]; then
  echo "Failed to insert order item; HTTP $ITEM_CODE" >&2
  echo "$ITEM_BODY" >&2
  exit 7
fi

ITEM_ID=$(echo "$ITEM_BODY" | python3 -c "import sys,json; a=json.load(sys.stdin); print(a[0].get('id',''))")
echo "Inserted order item id: $ITEM_ID"

# Test RLS: try to create order with different user_id
OTHER_USER_ID="00000000-0000-0000-0000-000000000000"
BAD_PAYLOAD=$(echo "$ORDER_PAYLOAD" | python3 -c "import sys,json; o=json.load(sys.stdin); o['user_id']='$OTHER_USER_ID'; print(json.dumps(o))")
BAD_RESP=$(curl -s -w "\n%{http_code}" -X POST "${SUPABASE_URL}/rest/v1/orders" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d "$BAD_PAYLOAD")
BAD_CODE=$(echo "$BAD_RESP" | tail -n1)

if [[ "$BAD_CODE" == "201" ]]; then
  echo "RLS check FAILED: was able to insert order for another user (HTTP 201)" >&2
  exit 8
else
  echo "RLS check OK: insert for different user returned HTTP $BAD_CODE"
fi

# Summary
cat <<SUMMARY
Integration test completed successfully.
Created order: ${ORDER_ID} (order_number: ${ORDER_NUMBER})
Created order_item: ${ITEM_ID}
RLS insert-different-user returned non-201 as expected.
SUMMARY

exit 0
