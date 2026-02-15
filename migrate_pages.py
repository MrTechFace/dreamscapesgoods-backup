import requests
import base64
import json

# Configuration
wp_url = "https://gold-deer-255133.hostingersite.com/wp-json/wp/v2"
user = "antigravity-access"
password = "R3toe3PJDDwx)A(SKzU@e&*B"

# Encode credentials
credentials = f"{user}:{password}"
token = base64.b64encode(credentials.encode()).decode()
headers = {
    'Authorization': f'Basic {token}',
    'Content-Type': 'application/json'
}

def create_page(title, content, status="publish"):
    url = f"{wp_url}/pages"
    data = {
        "title": title,
        "content": content,
        "status": status
    }
    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 201:
        print(f"Successfully created page: {title}")
        return response.json()
    else:
        print(f"Failed to create page: {title}")
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.text}")
        return None

# Test with About page
about_content = """
<!-- wp:heading -->
<h2>About Dreamscapes Goods</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>At Dreamscapes Goods, we create apparel that blends art, quality, and intention. Each design is crafted with care, inspired by imagination, and produced with modern technology to ensure both comfort and durability.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>Our Story</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Dreamscapes Goods began with a simple idea: to turn unique artwork into wearable pieces. What started as an exploration of creativity has grown into a curated collection of limited-edition apparel — designed for those who value originality and expression.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->
<h3>Our Mission</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>We believe clothing should be more than fabric. It should carry meaning. That’s why every item we create is designed to feel special, timeless, and authentic — whether it’s a bold graphic or a subtle tone-on-tone embroidery.</p>
<!-- /wp:paragraph -->
"""

if __name__ == "__main__":
    create_page("About", about_content)
