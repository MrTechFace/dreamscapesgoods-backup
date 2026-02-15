# Dreamscapes Goods - Automated Backup

Automated daily backup of https://dreamscapesgoods.com

## Backup Schedule

- **Automatic:** Daily at 3 AM UTC
- **Manual:** Run workflow manually from GitHub Actions tab

## Contents

Full mirror of the Dreamscapes Goods website including:
- HTML pages
- Images and assets
- CSS and JavaScript
- Product pages

## Restoration

To restore or view locally:
```bash
cd backup
python3 -m http.server 8080
# Visit http://localhost:8080
```

---

*Automated backup via GitHub Actions*
