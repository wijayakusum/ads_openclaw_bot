# AdSense Implementation Plan — Hotel Package Stay (Checkout Page)  
Site: https://balitatittour.com  
Category: Hotel Package Stay  
Page: Checkout / Payment / Room selection (pages where guest enters details, selects room/extras, pays)

Summary: Checkout pages are conversion‑critical. Best practice: no AdSense or third‑party ad creatives on checkout/payment pages. This document is implementation‑ready: exact block names, Auto Ads guidance, enforceable suppression rules, policy checklist, and a 7‑day verification/test plan with KPI targets.

---

## 1) Placements — block names (RECOMMENDATION: NO ADS)

Treat checkout pages as ad‑free. Use these reserved block names for templates and logs — they must **not** contain ad creatives.

| Block name | Purpose (checkout) | Allowed? |
|---|---:|---|
| checkout-hero | Heading, reservation summary (non‑ad) | Yes (site content only) |
| price-breakdown-guard | Price, taxes, fees, room summary (reserved) | Yes — **NO ADS** |
| checkout-form | Guest details / payment form container | Yes — **NO ADS** |
| extras-guard | Add‑ons / room extras area (reserved) | Yes — **NO ADS** |
| help-inline | Support phone, trust badges, payment methods (site content) | Yes (non‑ad only) |
| post-confirmation-slot | Thank‑you page only — ad allowed below confirmation | Allowed on confirmation page (not checkout) |
| ad-placeholder-guard | Template placeholder (must remain empty on checkout) | MUST be empty — no ad tags |

Notes:
- If the site requires messaging on checkout, use `help-inline` (site‑owned content) only — never third‑party ad creatives.
- Confirmation/thank‑you page may host a conservative ad **below** the confirmation (see policy), but not on checkout pages.

---

## 2) Auto Ads — ON / OFF

| Auto Ads format | Recommendation for checkout pages |
|---|---|
| Display (responsive) | OFF for checkout pages — **exclude** checkout URL patterns in Auto Ads |
| In‑article | OFF |
| In‑feed / Matched content | OFF |
| Anchor (sticky) | OFF (globally or excluded for checkout flows) |
| Vignette / Interstitial | OFF |
| Auto Ads URL exclusions | REQUIRED — add all checkout/payment/room selection/confirm URL patterns |

Action items:
- In AdSense Auto Ads settings, add checkout path patterns (exact site routes) to exclusion list.
- Confirm via Auto Ads reports there are no placements on excluded pages.

---

## 3) Conversion‑safe suppression zones — enforceable rules

Server‑side suppression is mandatory. Client fallback only if server flag absent.

A. Server‑side (MANDATORY)
- All checkout/payment route handlers must set `isCheckoutPage = true`. If true, **do not render any ad slot HTML** and **do not include ad network scripts** in the response.

B. Client‑side fallback (early)
- Add a tiny inline script before ad libs:
  - If `document.body.dataset.pageType === 'checkout'` then remove `.ad-slot` nodes and set `window.ADS_DISABLED_FOR_CHECKOUT = true` to block lazy ad loaders.

C. Reserved no‑ad zones (must never host ads)
- `price-breakdown-guard`, `extras-guard`, and `checkout-form` are permanent no‑ad areas. No third‑party content that could be confused with payments or prices may be placed nearby.

D. Session & referral suppression
- When user enters checkout, set `sessionStorage.ads_suppressed = '1'`. Persist suppression across same‑session navigations until booking completes or session expires.
- If user arrived from paid campaign (`utm_medium=cpc` & `utm_campaign` indicates booking intent), ensure suppression during the flow.

E. Thank‑you behavior
- On confirmation page only, a single conservative ad may be allowed **below** confirmation text (`post-confirmation-slot`) after at least 1s delay and clear visual separation. Prefer site-owned upsell links over third‑party ads.

Developer checklist
1. Add `isCheckoutPage` server flag for checkout routes.  
2. Do not include ad HTML or ad scripts when flag true.  
3. Add inline client guard to remove stray ad DOM nodes.  
4. Add Auto Ads URL exclusions for checkout paths.  
5. Log any ad render attempts on checkout pages and alert ops.

Example server pseudocode
```py
checkout_routes = ['/hotel/checkout','/hotel/payment','/hotel/room-select','/hotel/confirm']
page.isCheckoutPage = request.path in checkout_routes
# in template
<body data-page-type="{{ 'checkout' if page.isCheckoutPage else 'default' }}">
  {% if not page.isCheckoutPage %}
    <!-- render ad placeholders -->
  {% endif %}
  <!-- checkout UI -->
</body>
```

Client guard (pasteable)
```html
<script>
  (function(){
    var isCheckout = document.body && document.body.dataset && document.body.dataset.pageType === 'checkout';
    if (isCheckout) {
      window.ADS_DISABLED_FOR_CHECKOUT = true;
      document.querySelectorAll('.ad-slot, .adsbygoogle, iframe[src*="googlesyndication"]').forEach(function(n){ try{ n.remove(); }catch(e){} });
    }
  })();
</script>
```

---

## 4) Policy checklist — must follow

Hard rules (no exceptions)
- NO AdSense or third‑party ad creatives on checkout, seat selection, payment pages.  
- NO anchor/sticky ads that overlap payment buttons or form fields.  
- NO interstitials or popups that interrupt payment.

UX & legal
- Display price, taxes, fees, cancellation/refund policy clearly and near payment controls. Ads must not be placed in ways that could be mistaken for pricing or confirmation content.
- Consent banner must not obstruct payment controls.

Third‑party widgets
- If payment/booking uses third‑party iframe:
  - Parent page must be primary content (not an ad shell).  
  - Do not permit iframe to inject ads. Ads must be outside widget boundaries.  
  - Ensure PCI/security requirements are not impacted by ad scripts.

Security & privacy
- Checkout pages must be HTTPS. Do not expose PII to ad networks.  
- Do not include ad scripts that access payment or form fields.

Invalid traffic & monitoring
- Monitor for ad calls from checkout URLs. Any non‑zero occurrence → immediate disable of Auto Ads and ad scripts and incident investigation.

Logging & alerting
- Log ad render attempts on checkout routes. Alert ops if any occur.

---

## 5) 7‑Day Test Plan with KPI targets (verification)

Goal: verify checkout pages are ad‑free, Auto Ads exclusions effective, and conversion metrics stable (or improve) after enforcing suppression.

Test type: enforcement + monitoring (not A/B). Validate suppression is effective and measure conversion health.

Duration: 7 days after deployment.

Daily metrics & goals

| KPI | What to measure | Target |
|---|---|---|
| Ad network requests from checkout pages | Network calls to ad domains originating from checkout URLs | **0** |
| Checkout conversion rate (completed bookings) | % of checkout sessions that finish booking | ≥ baseline (no drop) |
| Checkout abandonment rate | % users leaving during checkout | ≤ baseline (no increase) |
| Auto Ads placements on excluded URLs | Auto Ads console placements for excluded URLs | **0** |
| LCP / CLS on checkout pages | Page performance metrics | No regression (≤ +10% change) |
| Incidents logged | Any ad render attempts on checkout routes | **0** |

Acceptance thresholds & actions
- Any ad request from a checkout URL: immediate remediation — disable Auto Ads and ad scripts, and investigate.
- Booking CVR drop >3% vs baseline: investigate; rollback recent unrelated changes if cause unclear.
- Checkout abandonment increase >5%: investigate for UX or script issues and remediate.

Day-by-day plan
- **Day 0 (deploy)**: Implement server-side suppression, inline client guard, add Auto Ads exclusions, enable logging and alerting.
- **Day 1**: Smoke test in incognito — open checkout and inspect Network tab for ad calls (should be none). Confirm Auto Ads exclusion in AdSense UI.
- **Days 1–2**: Monitor logs and conversion metrics hourly for first 48 hours.
- **Days 3–6**: Daily checks of conversion and performance metrics; inspect logs for ad calls.
- **Day 7**: Produce verification report: ad requests = 0, conversions stable, performance within tolerance. If any ad calls occurred, execute emergency remediation.

Emergency remediation steps (if leakage)
1. Immediately disable Auto Ads in AdSense UI.  
2. Remove ad scripts from checkout templates and deploy hotfix.  
3. Confirm server suppression and re-test.  
4. Notify stakeholders and run RCA.

---

## Implementation checklist (developer handoff)

1. Identify checkout/payment route patterns and set `isCheckoutPage = true`.  
2. Do not render ad slot HTML or include ad scripts when `isCheckoutPage` is true.  
3. Add early inline client guard to remove any stray ad DOM items.  
4. Configure Auto Ads exclusions for checkout URL patterns.  
5. Add server logging for any ad network calls from checkout routes and set alerts.  
6. Smoke test (Network tab) and begin 7‑day monitoring.

---

If you would like, I can generate next:
- a ready‑to‑paste server template snippet for Node/Django/PHP;  
- the exact inline JS guard snippet formatted for your template;  
- the Auto Ads exclusion list lines ready to paste into AdSense.  

Which do you want now?
