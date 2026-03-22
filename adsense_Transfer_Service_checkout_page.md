# AdSense Implementation Plan — Transfer Service (Checkout Page)  
Site: https://balitatittour.com  
Category: Transfer Service  
Page: Checkout / Payment / Seat Selection (pages where users enter passenger details, select options, and pay)

Summary: Checkout pages are conversion‑critical and high‑risk for accidental clicks. Recommended approach: zero AdSense ad creatives on checkout pages (server‑side suppression). Below is an implementation‑ready plan (placements, Auto Ads settings, suppression rules, policy checklist, 7‑day verification test) you can hand to dev/ops.

---

## 1) Placements — block names (recommended action: NO ADS on checkout pages)

Use these reserved block names in templates for clarity and monitoring. All ad slots must be disabled server‑side on checkout routes.

| Block name | Purpose on checkout page | Allowed? |
|---|---|---|
| checkout-hero | Page title / time left summary (non‑ad) | Allowed (non‑ad only) |
| price-summary-guard | Price, fees, taxes area (reserved) | Allowed (NO ads) |
| checkout-form | Primary booking/payment form container | Allowed (form only, NO ads) |
| help-inline | Small site-owned help/support links / trusted badges | Allowed (non‑ad only) |
| post-confirmation-slot | Thank‑you page slot — **not** checkout | Ads allowed on confirmation page only (below confirmation text) |
| ad-placeholder-guard | Template placeholder name (must be empty on checkout) | Must remain empty — do NOT render ad tags |

Implementation rule: Do not output any AdSense/gpt/ad network tags on pages where `isCheckoutPage === true`. If any informational content is needed, use site‑owned `help-inline` (no third‑party ad creatives).

---

## 2) Auto Ads — ON / OFF guidance

| Auto Ads format | Recommendation for checkout pages |
|---|---|
| Display (responsive) | OFF — exclude checkout URLs from Auto Ads |
| In‑article | OFF |
| In‑feed / Matched content | OFF |
| Anchor (sticky) | OFF (globally or at least for checkout paths) |
| Vignette / Interstitial | OFF |
| Auto Ads URL exclusions | REQUIRED — add checkout/payment/seat selection/confirm URL patterns to exclusions list |

Action items:
- In AdSense → Auto ads: add all checkout/payment URL patterns to exclusion list (exact paths used by site).
- Verify Auto Ads report after changes to confirm no placements on excluded pages.

---

## 3) Conversion‑safe suppression zones — exact enforceable rules

Prefer server‑side suppression; client fallback only if server flag missing.

A. Server‑side suppression (MANDATORY)
- Template must set `isCheckoutPage = true` for all checkout/payment routes.
- If `isCheckoutPage === true`, server must NOT render any ad-slot HTML or include ad network script tags in the page response.

B. Client‑side fallback (early-run)
- Very early inline script (placed before ad libs) should:
  - If `document.body.dataset.pageType === 'checkout'` then remove any `.ad-slot` elements and set a global flag to prevent ad loaders from executing.
  - Example: `window.ADS_DISABLED_FOR_CHECKOUT = true`.

C. Proximity & reserved zones (for non‑ad content)
- `price-summary-guard` is a permanent no‑ad zone — do not inject any third‑party content here.
- If `help-inline` appears, it must be site owned (help links, trust badges) and visually separated from payment controls.

D. Session & referral rules
- Persist `ads_suppressed = true` in sessionStorage for checkout flows. If user navigates away and returns, suppression remains.
- If user arrived via paid booking campaign (`utm_medium=cpc` & campaign contains BOOK/TRANSFER), ensure suppression during the booking flow.

E. Post‑payment (thank‑you) behavior
- On confirmation/thank‑you page you may allow a single conservative ad below the confirmation message (post-confirmation-slot) — only after a 1+ second delay, clearly visually separated from confirmation content. Prefer site-owned upsell or recommended next-steps over third‑party ads.

Developer checklist (server + client)
1. Add `isCheckoutPage` boolean in server template for checkout/payment routes.  
2. If true, do not output any ad slot markup or ad network scripts.  
3. Add tiny inline JS at top of page to remove `.ad-slot` and set `window.ADS_DISABLED_FOR_CHECKOUT = true` if server flag omitted.  
4. Add Auto Ads exclusions for checkout URL patterns.  
5. Log attempts to render ads on checkout pages and alert ops if any occur.

---

## 4) Policy checklist (must follow)

Hard prohibitions (checkout pages)
- NO AdSense creatives or any third‑party ad creatives on checkout, seat selection, or payment pages.
- NO anchor/sticky ads that could cover payment buttons or form fields.
- NO interstitials or auto‑redirecting creatives.

UX & legal
- Display price, taxes, fees, cancellation/refund policy clearly near payment UI — do not place any ad or third‑party content nearby.
- Consent UI must not block payment controls; personalize ads only after explicit consent (where required).

Third‑party widgets
- If payment or booking widget is an iframe:
  - Parent page must be primary content (not an ad shell).
  - Do NOT render ad creatives that could be confused with payment UI.
  - Do not permit iframe to inject ads.

Security & compliance
- Checkout pages must use HTTPS and not load scripts that alter security indicators.
- Do not send PII to ad networks.

Invalid traffic & click safety
- Monitor for ad impressions/clicks reported from checkout URL patterns; any non‑zero must trigger immediate investigation and disabling of ad scripts.

Logging & alerting
- Log ad render attempts on checkout pages with route, timestamp, and session id. Alert on any occurrence.

---

## 5) 7‑Day Test Plan with KPI targets (verification, not A/B)

Purpose: verify that checkout pages are ad‑free, Auto Ads exclusions are effective, and conversion metrics are stable (or improve) after suppression.

Test type: Enforcement + verification (no ad experiments on checkout pages).

Duration: 7 days after deployment.

Metrics & checks (daily)

| KPI | Description | Goal |
|---|---:|---|
| Ad requests from checkout pages | Count network requests to ad domains (adsense, googlesyndication, doubleclick, gpt, etc.) originating from checkout URLs | **0** requests |
| Checkout conversion rate (bookings completed) | % sessions starting checkout that complete booking | ≥ baseline (no decrease) |
| Checkout abandonment rate | % users who drop at payment step | ≤ baseline (no increase) |
| Auto Ads placements on excluded URLs | Auto Ads console/report showing placements on excluded URLs | **0** placements |
| LCP / CLS on checkout pages | Page performance metrics | No regression (≤ +10% change) |
| Incidents logged | Any ad render attempts on checkout URLs | **0** incidents |

Action thresholds
- If any ad request (non-zero) appears from checkout URLs → immediate remediation (disable Auto Ads, disable ad scripts) and incident investigation.
- If Booking conversion rate drops >3% vs baseline → troubleshoot (may be unrelated; verify other changes), roll back if necessary.
- If abandonment increases >5% → investigate UX/scripts and roll back recent changes.

Day‑by‑day tasks
- **Day 0 (deploy)**: Implement server-side suppression, client fallback, add Auto Ads exclusions, enable logging and alerting for ad requests on checkout URLs.
- **Day 1**: Smoke test in incognito — open checkout, inspect Network tab for any ad calls (should be none). Verify Auto Ads exclusion immediately in AdSense UI.
- **Days 1–2**: Monitor ad request logs and conversion metrics hourly for first 48 hours.
- **Days 3–6**: Daily checks of conversion and performance metrics; review logs for attempted ad renders.
- **Day 7**: Final verification and report: confirm 0 ad requests, conversion KPIs stable or improved, performance metrics acceptable.

Emergency remediation (if any ad leakage)
1. Disable Auto Ads globally while investigating.  
2. Remove/disable any ad vendor scripts in checkout templates.  
3. Deploy hotfix: ensure `isCheckoutPage` prevents any ad HTML output server-side.  
4. Notify stakeholders and run incident RCA.

---

## Quick implementation snippets (developer-friendly)

Server pseudocode (template)
```py
# route matching
checkout_routes = ['/transfer/checkout','/transfer/payment','/transfer/seat-select']
page.isCheckoutPage = request.path in checkout_routes

# template
<body data-page-type="{{ 'checkout' if page.isCheckoutPage else 'default' }}">
  {% if not page.isCheckoutPage %}
    <!-- render ad placeholders -->
  {% endif %}
  <!-- checkout form and content -->
</body>
```

Client-side guard (inline, placed before ad libs)
```html
<script>
  (function(){
    var isCheckout = document.body && document.body.dataset && document.body.dataset.pageType === 'checkout';
    if (isCheckout) {
      window.ADS_DISABLED_FOR_CHECKOUT = true;
      // remove any ad slot nodes quickly
      document.querySelectorAll('.ad-slot, .adsbygoogle, iframe[src*="googlesyndication"]').forEach(function(n){
        try{ n.remove(); } catch(e){}
      });
    }
  })();
</script>
```

Auto Ads exclusion list (examples to paste in AdSense)
- /transfer/checkout  
- /transfer/booking  
- /transfer/payment  
- /transfer/seat-select  
- /transfer/confirm  
- /transfer/thank-you

Monitoring: simple server log rule
- Log any outbound request where `request.path` matches checkout route and network host in [adsense domains list]. Alert if count > 0.

---

If you’d like, I can now:
- Generate the exact server template snippet for your tech stack (e.g., Node/EJS, Django/Jinja, PHP/Blade).  
- Produce the small inline JS guard ready to copy/paste.  
- Produce the exact list of Auto Ads exclusion patterns you can paste into AdSense.

Which one should I produce now?
