import requests

url = "https://gold-deer-255133.hostingersite.com/shop/"
try:
    response = requests.get(url, timeout=10)
    if "hover-image" in response.text:
        print("SUCCESS: 'hover-image' found in HTML.")
        # Print a snippet around the match
        index = response.text.find("hover-image")
        start = max(0, index - 100)
        end = min(len(response.text), index + 200)
        print(f"Context: ...{response.text[start:end]}...")
    else:
        print("FAILURE: 'hover-image' NOT found in HTML.")
        print("This means the PHP plugin is not running or not injecting the image.")
except Exception as e:
    print(f"Error fetching URL: {e}")
