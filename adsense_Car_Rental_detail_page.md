# AdSense Implementation Plan — Car Rental (Detail Page)  
Site: https://balitatittour.com  
Page: Car rental detail (single car option — vehicle details, specs, price, availability, pickup/drop, Book CTA)

Practical, implementation‑ready plan developers and monetization owners can apply. Goals: capture safe RPM from detail pages while protecting booking UX and avoiding accidental ad clicks.

---

1) Placements — block names, sizes, positions & rules

Use these canonical block names in templates and logs so monitoring and experiments map cleanly to data.

| Block name | Position | Sizes (recommended) | Rules / Notes |
|---|---:|---:|---|
| hero-banner | Immediately under hero image / title (desktop only) | 728×90 or responsive | Desktop only. Render only if Book CTA remains above fold. |
| inline-1 | In-content after short summary / specs (below first 150–300px) | 300×250 responsive or 336×280 | Primary in-article unit. Lazy‑load. Ensure ≥350px vertical distance from booking CTA. |
| inline-2 | Mid-article (after long description or reviews) | 300×250 responsive | Optional for long pages (>800 words). Only one. |
| sidebar-1 | Right rail beside price/availability (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile. Must not overlap price box. |
| mobile-inline | Mobile in-content slot (after summary) | 320×100 responsive | Only one mobile inline above fold and only if it does not push CTA below fold. |
| post-content-1 | Bottom of page after details, policies, reviews | 300×250 responsive | Lazy‑load at end of content; least interference. |
| price-guard | Reserved no-ad block around price/availability | N/A (non-ad zone) | No ads allowed here — prevents confusion with price/CTA. |
| sticky-anchor | Mobile sticky footer | 320×50 | Not recommended for booking pages. If used on informational pages, include visible close and hide for paid/booking sessions. |
| confirmation-slot | Confirmation page only | responsive small display | DO NOT render on detail page if booking continues on site. |

Practical caps:
- Desktop: maximum 2 ad units visible in the initial viewport.
- Mobile: maximum 1 ad unit visible in the initial viewport.
- Always reserve CSS height for each slot to avoid CLS (see suppression & test sections).

---

2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Car detail override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON but controlled by page flags | Useful complement to manual units when controlled. |
| In‑article | ON | ON for long editorial detail pages (>800 words); OFF for short transactional pages | Use only where content is long enough to accommodate ad without harming CTA visibility. |
| In‑feed / Matched content | ON if eligible | OFF | Not applicable to single detail pages; avoid in-feed injection here. |
| Anchor (sticky) | OFF | FORCE OFF when `booking_sensitive=true` | Sticky can obscure/book CTA and produce accidental clicks. |
| Vignette / Interstitial | OFF | FORCE OFF | Interruptive to booking flow — disallowed for this page type. |
| Auto Ads URL exclusions | — | Exclude `/booking`, `/checkout`, `/payment`, `/seat-select`, `/thank-you` and inline booking endpoints | Ensure conversion pages are ad-free. |

Implementation notes:
- Add page-level attributes: e.g., `<body data-ads-type="car-detail" data-booking-sensitive="true">`.
- Auto Ads and site ad-renderer should read these flags and not inject disallowed formats.
- Verify Auto Ads dashboard after launch that no anchor/interstitial appears on booking-sensitive pages.

---

3) Conversion-safe suppression zones — exact rules

Server-side checks are preferred; client-side distance checks are fallback.

A. Template / server flag
- `booking_sensitive = true` set for detail pages that include visible booking widget, price badge, calendar/pax selector, or immediate Book CTA. All ad code must check this before rendering.

B. Spatial suppression rules (enforceable)
- Do not render any ad-slot whose top edge is within **350px vertical** of `.price`, `.availability`, `#booking-form`, `.book-cta`, or calendar/pax selectors.
- `price-guard` is a reserved no-ad area — never render ads inside it.
- `inline-1` must not be placed directly above `.book-cta`; maintain at least **400px** separation.
- On mobile always hide `sidebar-1`.

C. Session & referral suppression
- If the user arrives with `utm_medium=cpc` and the campaign indicates booking intent (contains BOOK/RENT), suppress inline ads for that session (30–60 minutes) to preserve conversion focus.
- If the user clicks any Book CTA, continue suppression for the rest of that session.

D. Checkout/payment pages
- Server-side: do not serve ads on `/booking`, `/checkout`, `/payment`, `/seat-select`, or `/thank-you`.

E. Lazy-load behavior
- Only request ad creatives when slot is within **400px** of the viewport (IntersectionObserver). Above-the-fold slots may load immediately but must pass distance checks.

Developer checklist (priority)
1. Add `booking_sensitive` to template context (server).  
2. Server-side placement decisions before returning HTML; fallback to client-side distance check before ad request.  
3. IntersectionObserver with 400px threshold for lazy-load.  
4. Session suppression (sessionStorage / first-party cookie) for paid visitors.

---

4) Policy checklist — must follow

Placement & UX
- No ads inside, overlapping, or mimicking price, availability, seat selection, or Book CTA.
- Avoid anchor/sticky ads on booking-sensitive pages.
- Do not use interstitials on pages that lead directly to booking.

Affiliate & widget compliance
- If embedding third‑party booking widgets or partner flows:
  - Parent page must contain the primary content.  
  - Display clear affiliate disclosure near the CTA: e.g., “Partner booking. Commissions may apply.”  
  - Do not permit third‑party iframes to render ads inside the iframe; ads must be outside widget bounds.  
  - Ensure any affiliate-driven price/availability is accurate.

Content moderation & image rights
- Use licensed/owned images only. Do not display copyrighted images without permission.  
- Moderate UGC (reviews) for profanity, PII, or copyright issues. Label paid or incentivized reviews.

Privacy & consent
- Comply with GDPR/CCPA: do not serve personalized ads before required consent where applicable.  
- Make Privacy Policy link visible and ensure consent UI does not block booking controls.

Invalid traffic & click safety
- Monitor for CTR anomalies on booking-sensitive pages; high CTR with low conversions may indicate accidental clicks—pause placements and investigate.
- Implement click‑monitoring alerts for booking pages.

Logging & auditing
- Log ad slots served per session with page flags (`booking_sensitive`) and UTM source to analyze ad exposure vs conversions.

---

5) 7‑Day Test Plan with KPI targets

Objective: add safe monetization to car rental detail pages and measure conversion impact.

Test design: randomized A/B split (50% Control / 50% Test)
- Control (A): current page (no or conservative ads on detail page).
- Test (B): `inline-1` (after summary), `post-content-1` (bottom), `sidebar-1` (desktop). `hero-banner` optional only on non-sensitive pages. Enforce suppression and session rules. Auto in‑article ON for long pages; Anchor/Vignette OFF.

Duration & sample size
- 7 days or until **≥3,000 detail pageviews per variant**.

Metrics to capture daily
- Detail pageviews  
- Book CTA Click‑Through Rate (Book CTR)  
- Booking conversion rate (CVR) from detail page sessions  
- Page RPM (AdSense)  
- Ad CTR (per-slot)  
- CLS & LCP  
- Bounce rate and time on page

KPI table — baseline vs targets & action thresholds

| KPI | Baseline | Test target | Immediate action threshold |
|---|---:|---:|---|
| Book CTR | baseline | No decrease >4% relative | If drop >4% pause Test B immediately |
| Booking CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental-click spikes | If CTR spikes & conversions low pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholders and defer ad loads |
| LCP (mobile) | baseline | ≤+15% increase | If >+15% optimize assets or defer ads |
| Bounce rate | baseline | Not increase >7% | If increase >7% inspect ad interference |

Day-by-day execution
- Day 0: implement ad placeholders with reserved CSS heights; add `booking_sensitive` flag; implement server-side insertion with separation rules; configure GTM A/B split and GA4 events: `car_detail_view`, `book_cta_click`, `booking_started`, `booking_confirmed`.
- Day 1 (launch): start 50/50 split. Monitor hourly first 6–8 hours for JS errors, ad disapprovals, CTR anomalies.
- Days 2–3: daily reviews. If Book CTR or CVR shows >3% negative trend, reduce density (remove `sidebar-1` or move `inline-1` further down).
- Day 4: mid-test optimization if needed.
- Day 6: final adjustments.
- Day 7: analyze results. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and iterate with lower density or alternate placements.

Reporting deliverable
- One-page summary: RPM delta, Book CTR delta, CVR delta, per-slot CTR, CLS/LCP deltas, recommended steady-state config.

---

Quick developer handoff snippets

CSS placeholders
```css
.ad-inline-1 { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
.ad-hero-banner { width:100%; min-height:90px; }
.price-guard { min-width:200px; min-height:80px; /* reserved non-ad area */ }
[data-booking-sensitive="true"] .ad-hero-banner { display:none !important; }
```

JS suppression pseudocode
```js
if (page.booking_sensitive) {
  const cta = document.querySelector('#booking-form');
  document.querySelectorAll('.ad-slot').forEach(slot => {
    const slotTop = slot.getBoundingClientRect().top + window.scrollY;
    const ctaBottom = cta.getBoundingClientRect().bottom + window.scrollY;
    if (slotTop - ctaBottom < 350) slot.style.display = 'none';
  });
  if (location.search.includes('utm_medium=cpc') && location.search.includes('BOOK')) {
    sessionStorage.setItem('ads_suppressed','1');
  }
  if (sessionStorage.getItem('ads_suppressed') === '1') {
    document.querySelectorAll('.in-article-ad').forEach(a => a.style.display='none');
  }
}
```

GTM / GA4 events to create
- `car_detail_view` (page load)  
- `book_cta_click` (click)  
- `booking_started` (form submit)  
- `booking_confirmed` (thank-you page view)

Logging recommendation
- Log per ad request: `page_type`, `category`, `booking_sensitive`, `session_source` (utm), `slot_name`, `creative_id` for post-test correlation analysis.

---

If you’d like I can:
- Provide ready-to-paste HTML/CSS ad-slot markup and the exact IntersectionObserver code snippet.
- Generate a GTM container JSON for A/B split and the GA4 event tags for import.
- Build a GA4 dashboard spec to track the KPIs during the 7‑day test.

Which artifact should I prepare next?
