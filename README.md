# Oslo Graphics — integrated GitHub-ready website

This package combines the newer multi-page Oslo Graphics website (including its Supabase-powered editable content/admin structure) with the previous single-page site's product range and original product photographs.

## Included
- Home, Products, Services, Portfolio, About, FAQ, Contact and Get a Quote pages.
- Previous site's product photography and range: polos, T-shirts, hoodies, caps, reflector vests, helmets and team/event branding.
- Refined colour system: deep navy, warm ivory, muted olive and restrained brass.
- Subtle photo treatment only: slight saturation/contrast refinement.
- Floating WhatsApp and Call actions.
- Product-specific quote links and WhatsApp enquiry flow.
- Existing admin, Supabase configuration and schema files retained.

## Publish with GitHub Pages
1. Extract this ZIP and open the extracted folder.
2. Upload all files and the `assets` folder to the root of your GitHub repository.
3. Open **Settings → Pages**.
4. Choose **Deploy from a branch**, select `main` and `/(root)`, then Save.

## Shop, cart and orders
- Products have a `price` (placeholder values: change them in the admin). Customers add to cart, check out, get a receipt and confirm on WhatsApp.
- Orders and visit counts are saved in Supabase (tables `orders`, `visits`) and shown in the admin under Orders and sales.
- Set `till` in the contact section of the admin to show your M-Pesa Till on receipts. Real STK push needs a server function and the Safaricom Daraja API.
- Discount codes live under Offers in the admin. They are checked in the browser, so treat them as marketing codes, not security.

## Make the website editable
- Change default wording, products, photos and contact details in `content.js`.
- For live editing through the admin page, configure `config.js`, then run `supabase-schema.sql` in Supabase SQL Editor.
- Replace `OWNER_EMAIL_HERE` in the SQL schema with the actual admin email before running it.
- Open `admin.html` on the published website to sign in and edit supported content.
- The admin photo uploader uses the `site-images` Supabase Storage bucket.

## Important
- `config.js` must contain only the Supabase Project URL and public anon/publishable key. Never put a `service_role` or secret key in browser files.
- **0797 265 412** is customer care (used for calls and WhatsApp). **0720 055 885** is the business owner's number, shown on the Contact page. Both are in `content.js` (`phone`, `whatsapp`, `ownerPhone`) and editable in the admin.
- The previous single-file website used browser-local storage for some cart/admin features. Those local-only features are not secure shared checkout/order management; this integrated site directs customers to request quotes and contact the business on WhatsApp.
- M-Pesa payments are not integrated. Real checkout requires secured server-side payment processing and transaction verification.
- Review Supabase RLS and Storage permissions before using the admin page publicly.

## Main files
- `index.html` — home
- `products.html` — product catalogue
- `quote.html` — quote request form
- `admin.html` — content editor
- `content.js` — editable default content
- `style.css` — design and colour grading
- `assets/products/` — original product photographs carried over from the previous site
