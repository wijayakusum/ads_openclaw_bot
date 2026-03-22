# AdSense Implementation Plan — Car Rental (Checkout Page)  
Site: https://balitatittour.com  
Category: Car Rental  
Page: Checkout / Payment / Seat Selection (pages where user enters passenger details, selects extras, pays)

Summary: Checkout pages are conversion‑critical and must be treated as ad‑free by default. This plan is implementation‑ready: precise block names, Auto Ads settings, enforceable suppression rules, policy checklist, and a 7‑day verification test with KPI targets.

---

## 1) Placements (block names) — recommended action: NO ADS on checkout pages

All ad creatives and ad network scripts must be blocked server‑side on checkout/payment pages. Use these reserved block names for templates and logs — do **not** populate them with ad tags:

| Block name | Purpose on checkout page | Allowed? |
|---|---:|---|
| checkout-hero | Page title and short instructions (non‑ad) | Allowed (non‑ad only) |
| price-summary-guard | Price breakdown, taxes, fees (reserved) | Allowed (NO ads) |
| checkout-form | Primary booking/payment form container | Allowed (form only, NO ads) |
| extras-guard | Extras/options area (reserved) | Allowed (NO ads) |
| help-inline | Site‑owned help text, contact phone, trust badges | Allowed (non‑ad only) |
| post-confirmation-slot | Thank‑you page only — ad allowed below confirmation | Allowed only on confirmation page (not checkout) |
| ad-placeholder-guard | Template placeholder (must be empty on checkout) | MUST remain empty — no ad tags allowed |

Rationale: Ads on checkout risk accidental clicks, policy violations, and conversion loss. Treat checkout pages as ad‑free environments.

---

## 2) Auto Ads — ON / OFF

| Auto Ad format | Recommendation for checkout pages |
|---|---|
| Display (responsive) | OFF for checkout/payment pages — exclude these URLs from Auto Ads |
| In‑article | OFF |
| In‑feed / Matched content | OFF |
| Anchor (sticky) | OFF for checkout flows (globally or excluded paths) |
| Vignette / Interstitial | OFF |
| Auto Ads URL exclusions | REQUIRED — add checkout/payment/seat-select/confirm URL patterns to exclusion list |

Action steps
- In AdSense → Auto ads, add the checkout/payment URL patterns to the exclusions list (exact paths used by site).
- Confirm via AdSense/Auto Ads reports that exclusions are applied and no Auto placements occur for those URLs.

---

## 3) Conversion‑safe suppression zones — exact enforceable rules

Server‑side suppression is mandatory; client-side fallback only.

A. Server‑side suppression (MUST)
- All checkout/payment route templates must set a boolean `isCheckoutPage = true`. If true, server must not output any ad slot HTML nor include any ad network script tags in the response.

B. Client‑side fallback (early inline)
- Place a small inline script before any ad libs:
  - If `document.body.dataset.pageType === 'checkout'` or `window.ADS_DISABLED_FOR_CHECKOUT` is set, remove any `.ad-slot` nodes and set `window.ADS_DISABLED_FOR_CHECKOUT = true` to block ad loader logic.

C. Proximity & reserved zones
- Reserve `price-summary-guard` and `extras-guard` as permanent **no‑ad zones**. No third‑party content that looks like ads or payment UI may be placed here.
- Do not load any external content (iframes/widgets) near the payment button that could be mistaken for the payment flow.

D. Session & referral persistence
- Persist `ads_suppressed = true` in sessionStorage (or first‑party cookie) once user enters checkout flow (so suppression persists across internal redirects).

E. Post‑payment (thank‑you) allowance
- On the confirmation/thank‑you page, optionally allow one conservative ad block **below** the main confirmation message (post-confirmation-slot). Only show this after a 1+ second delay and clearly separated from confirmation/next-step actions. Prefer site-owned upsell links over third‑party ads.

Developer enforcement checklist (priority)
1. Implement `isCheckoutPage` server flag for all checkout routes.  
2. If true, do not render ad slot HTML or include ad provider scripts.  
3. Add inline top-of-page client guard to remove `.ad-slot` elements if server flag absent.  
4. Add Auto Ads URL exclusions for checkout patterns.  
5. Log any ad render attempts on checkout URLs and alert ops.

Example server pseudocode
```py
checkout_routes = ['/car/checkout','/car/payment','/car/seat-select','/car/confirm']
page.isCheckoutPage = request.path in checkout_routes

# template
<body data-page-type="{{ 'checkout' if page.isCheckoutPage else 'default' }}">
  {% if not page.isCheckoutPage %}
    <!-- render ad placeholders and scripts -->
  {% endif %}
  <!-- checkout form -->
</body>
```

Client-side guard (early)
```html
<script>
  (function(){
    var isCheckout = document.body && document.body.dataset && document.body.dataset.pageType === 'checkout';
    if (isCheckout) {
      window.ADS_DISABLED_FOR_CHECKOUT = true;
      document.querySelectorAll('.ad-slot, .adsbygoogle, iframe[src*="googlesyndication"]').forEach(n=>n.remove());
    }
  })();
</script>
```

---

## 4) Policy checklist — mandatory items

Hard rules (no exceptions)
- NO AdSense ad units or other third‑party advertising creatives on checkout, seat selection, payment, or pre‑confirmation pages.
- NO anchor/sticky ads that can overlap form fields or payment buttons.
- NO interstitials, popups, or other disruptive creatives in the payment flow.

UX & legal
- Show price breakdown, taxes, fees, cancellation & refund policies clearly and near the payment controls; do not place any third‑party content that might be confused with these elements.
- Consent UI must not obscure payment controls or be required to proceed with payment.

Third‑party widgets / iframes
- If a payment widget is embedded via iframe:
  - Parent page must be primary content.  
  - Do not allow iframe to render ads; ads must be outside iframe and not adjacent to payment controls.  
  - Verify PCI/third‑party provider does not inject ad scripts.

Security & compliance
- Checkout pages must be served over HTTPS. Do not alter or obscure security indicators with scripts.
- Do not send or expose PII to ad networks.

Invalid traffic protection
- Monitor analytics and logs for any ad calls from checkout URLs. Any ad request → immediate remediation and notification.

Logging & alerts
- Implement a server log rule to detect and alert on any ad network request originating from a checkout URL.

---

## 5) 7‑Day Test Plan with KPI targets (verification)

Goal: verify checkout pages are ad‑free, Auto Ads exclusions effective, and conversion metrics stable or improved.

Test type: Safety enforcement & monitoring (not A/B). Ensures no ads are present and measures conversion health.

Duration: 7 days post‑deployment.

Daily metrics & goals

| KPI | Metric | Goal |
|---|---:|---|
| Ad network requests from checkout pages | Count of network calls to ad domains originating from checkout URLs | **0** |
| Booking conversion rate (checkout → completed) | % of checkout sessions finishing booking | ≥ baseline (no decrease) |
| Checkout abandonment rate | % users leaving before finish | ≤ baseline (no increase) |
| Auto Ads placements on excluded URLs | Auto Ads console placements for excluded URLs | **0** |
| LCP / CLS on checkout pages | Performance metrics | No regression (≤ +10% change) |
| Incidents | Any ad request or impression logged from checkout URLs | **0** incidents |

Acceptance thresholds & actions
- Any ad request from checkout URL → immediate remediation: disable Auto Ads, remove ad scripts, investigate.
- Booking CVR drop >3% → investigate other changes; consider rolling back related deploys if unclear cause.
- Abandonment increase >5% → immediate UX debug; check scripts and page load.

Day-by-day plan
- **Day 0 (deploy)**: Implement server-side suppression, client fallback, Auto Ads exclusions, logging and alerting.
- **Day 1**: Smoke test in incognito: open checkout, check Network tab — no ad calls. Verify Auto Ads exclusion in AdSense UI.
- **Days 1–2**: Monitor logs and conversion metrics hourly for first 48 hours.
- **Days 3–6**: Daily checks on metrics; review logs for attempted ad renders.
- **Day 7**: Produce verification report confirming 0 ad requests, conversion KPIs stable, performance acceptable.

Emergency remediation steps (if ad leakage found)
1. Immediately disable Auto Ads in AdSense.  
2. Remove any ad scripts from checkout templates and deploy hotfix.  
3. Reinforce server flag `isCheckoutPage` and test.  
4. Notify stakeholders and run RCA.

---

## Implementation checklist (developer handoff)

1. Identify all checkout/payment URL patterns and set `isCheckoutPage = true`.  
2. Remove ad slot markup and ad script inclusion when `isCheckoutPage === true`.  
3. Add inline client guard at top of template to remove any stray ad DOM before ad libs load.  
4. Configure AdSense Auto Ads exclusions for these paths.  
5. Add server log rule to capture any ad network calls from checkout routes and alert if >0.  
6. Perform smoke tests (Network tab) and start 7‑day monitoring.

---

If you’d like, I can now generate:
- Ready‑to‑paste server template snippet for your stack (Node/EJS, Django/Jinja, PHP/Blade),  
- Exact inline JS guard ready to copy/paste, and  
- Auto Ads exclusion list lines formatted for direct copy into AdSense.

Which would you like next?
