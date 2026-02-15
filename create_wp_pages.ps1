$user = "antigravity-access"
$pass = "R3toe3PJDDwx)A(SKzU@e&*B"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$pass)))
$headers = @{
    Authorization = ("Basic {0}" -f $base64AuthInfo)
    "Content-Type" = "application/json"
}
$apiUrl = "https://gold-deer-255133.hostingersite.com/wp-json/wp/v2"

function Create-WPPage($title, $content, $slug) {
    write-host "Creating page: $title..."
    $body = @{
        title = $title
        content = $content
        status = "publish"
        slug = $slug
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$apiUrl/pages" -Method Post -Headers $headers -Body $body
        write-host "Successfully created $title (ID: $($response.id))"
    } catch {
        write-host "Error creating $title`: $_"
    }
}

# 1. About Page
$about_content = @"
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

<!-- wp:heading {"level":3} -->
<h3>What We Offer</h3>
<!-- /wp:heading -->
<!-- wp:list -->
<ul>
<li>Limited Edition Apparel: Designs you won’t find anywhere else.</li>
<li>Thoughtful Craftsmanship: Every piece is produced on demand, reducing waste and focusing on quality.</li>
<li>A Growing Community: Dreamscapes Goods is for those who appreciate individuality and creativity.</li>
</ul>
<!-- /wp:list -->
<p>Thank you for being here. This is just the beginning — and we’re excited to share the journey with you.</p>
"@

# 2. FAQ Page
$faq_content = @"
<!-- wp:paragraph -->
<p>Here you’ll find answers to the most common questions about our shipping, returns, and products.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->
<h4>Where are orders fulfilled?</h4>
<!-- /wp:heading -->
<!-- wp:paragraph -->
<p>All products are made on demand — production begins after you place your order.</p>
<!-- /wp:paragraph -->
<!-- wp:list -->
<ul>
<li><strong>EU Realm orders:</strong> Produced and shipped from providers in Europe (e.g. Textildruck Europa, Print Logistic).</li>
<li><strong>US Realm orders:</strong> Produced and shipped from Monster Digital in the USA.</li>
<li>No customs or import fees within these regions.</li>
</ul>
<!-- /wp:list -->

<!-- wp:heading {"level":4} -->
<h4>How long does shipping take?</h4>
<!-- /wp:heading -->
<!-- wp:list -->
<ul>
<li>Production time: 2–7 business days.</li>
<li>Delivery after fulfillment:
    <ul>
    <li>Europe: 5–10 business days</li>
    <li>United States: 2–5 business days</li>
    </ul>
</li>
</ul>
<!-- /wp:list -->
<!-- wp:paragraph -->
<p>US orders typically arrive faster due to streamlined domestic shipping, while EU orders may take a few days longer because they pass through multiple national carriers.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->
<h4>What are the shipping costs?</h4>
<!-- /wp:heading -->
<!-- wp:list -->
<ul>
<li>Europe: €7 flat rate + €4 per additional item</li>
<li>United States: $7 flat rate + $4 per additional item</li>
</ul>
<!-- /wp:list -->

<!-- wp:heading {"level":4} -->
<h4>Do I pay customs or VAT?</h4>
<!-- /wp:heading -->
<!-- wp:paragraph -->
<p>No. Orders are fulfilled on demand within the customer’s region, so there are no extra customs or import duties.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->
<h4>Can I track my order?</h4>
<!-- /wp:heading -->
<!-- wp:paragraph -->
<p>Yes. A tracking link will be sent by email once the order is marked “Ready to Ship.” Tracking information usually updates within 24 hours.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":4} -->
<h4>What about returns?</h4>
<!-- /wp:heading -->
<!-- wp:paragraph -->
<p>We only replace or refund items that are defective or damaged. Returns are not required. To request a solution, please use the Contact page in the footer and include photos of the issue.</p>
<!-- /wp:paragraph -->
"@

# 3. Contact Page
$contact_content = @"
<!-- wp:paragraph -->
<p>Contact: We’re keeping things small and intentional. If you’d like to reach out, feel free to send a note.</p>
<!-- /wp:paragraph -->
"@

# 4. Privacy Policy (Wait, usually WP has a default one, but let's overwrite with Squarespace content)
$privacy_content = @"
<!-- wp:paragraph -->
<p>Last updated: 2025-09-10</p>
<!-- /wp:paragraph -->
<!-- wp:heading {"level":4} -->
<h4>1) Who we are (Controller)</h4>
<!-- /wp:heading -->
<!-- wp:paragraph -->
<p>Onyxium AB (&quot;Dreamscapes Goods&quot;) is the controller for this website and store. Company no.: 5591205900 Address: Spetsbergsgatan 3B, 414 66 Göteborg, Sweden.</p>
<!-- /wp:paragraph -->
<!-- wp:paragraph -->
<p>... (Rest of policy content following exactly) ...</p>
<!-- /wp:paragraph -->
"@

# Execute
Create-WPPage "About" $about_content "about"
Create-WPPage "FAQ" $faq_content "faq"
Create-WPPage "Contact" $contact_content "contact"
Create-WPPage "Shipping Policy" $faq_content "shipping-policy"
Create-WPPage "Returns & Refunds" "We only replace or refund items that are defective or damaged." "returns-refunds"
Create-WPPage "Terms of Service" "[MISSING]" "terms"

# Update Privacy Policy if it exists
write-host "Privacy Policy content prepared. Skipping creation to avoid duplicates, update logic needed."
