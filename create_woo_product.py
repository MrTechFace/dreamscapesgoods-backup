import requests
from requests.auth import HTTPBasicAuth
import json

# WooCommerce API credentials
url = "https://gold-deer-255133.hostingersite.com/wp-json/wc/v3/products"
consumer_key = "ck_33d6290707d6bc6dd5f377088c21b8d717cfc7c1"
consumer_secret = "cs_88082d544360a7ada5e8841697b19134c7c8fefe"

# Product data
product_data = {
    "name": "Test Product - Simple",
    "type": "simple",
    "regular_price": "15.00",
    "description": "Simple test product to verify cart functionality",
    "short_description": "Test product",
    "manage_stock": False,
    "stock_status": "instock",
    "catalog_visibility": "visible"
}

# Create product
response = requests.post(
    url,
    auth=HTTPBasicAuth(consumer_key, consumer_secret),
    json=product_data
)

if response.status_code == 201:
    product = response.json()
    print(f"✅ Product created successfully!")
    print(f"Product ID: {product['id']}")
    print(f"Product URL: {product['permalink']}")
    print(f"\nNow test adding it to cart!")
else:
    print(f"❌ Error: {response.status_code}")
    print(response.text)
