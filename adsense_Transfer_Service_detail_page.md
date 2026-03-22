# AdSense Implementation Plan — Transfer Service (Detail Page)  
Site: https://balitatittour.com  
Page: Transfer service detail (single transfer option — vehicle type, schedule, price, pickup, Book CTA)

Practical, implementation‑ready guidance developers and monetization owners can apply immediately. Priority: protect bookings and UX, avoid accidental clicks, and capture safe RPM from content sections.

---

## 1) Placements — block names, sizes, position & rules

Use these block names in templates so analytics and logs can reference them.

| Block name | Position (desktop / mobile) | Sizes (recommended) | Rules / Notes |
|---|---:|---:|---|
| hero-banner | Under hero image / title (desktop only) | 728×90 or responsive | Desktop only. Show only if Book CTA remains above the fold. |
| inline-1 | In-content after short summary / pickup details | 300×250 responsive / 336×280 | Primary in-article unit. Lazy load. Ensure ≥350px vertical distance from booking CTA. |
| sidebar-1 | Right rail beside price/availability (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile. Do not overlap price box. |
| mobile-inline | Mobile in-content (after summary) | 320×100 responsive | Only one mobile in-article allowed above fold and only if it does not push CTA below fold. |
| post-content-1 | Bottom of page after full details, policies, reviews | 300×250 responsive | Lazy‑load at end of content; best low-interference spot. |
| sticky-anchor | Mobile sticky footer | 320×50 | NOT recommended on booking-heavy detail pages; if used, enable only on informational pages with explicit close button. |
| price-ad-guard | (reserved area) adjacent to price | N/A (reserved non-ad area) | No ads allowed inside this block — reserved to prevent confusion with price/CTA. |
| confirmation-slot | Confirmation page only (not on detail) | responsive small display | DO NOT serve on detail page if booking continues on-site. |

Practical caps
- Desktop: max 2 ad units visible in initial viewport.
- Mobile: max 1 ad unit visible in initial viewport.
- Reserve CSS height for each slot to avoid layout shifts.

---

## 2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Transfer detail page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON but controlled by page flags | Good inventory; subject to suppression checks. |
| In‑article | ON | ON for long descriptive pages; OFF for short transactional pages | Use only when page content is long enough (>800 words). |
| In‑feed / Matched content | ON if eligible | OFF | Not relevant for single detail pages. |
| Anchor (sticky) | OFF (recommended) | FORCE OFF on booking-heavy pages | Sticky can obscure CTAs and cause accidental clicks. |
| Vignette / Interstitial | OFF | FORCE OFF | Disruptive to booking flow. |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /payment /seat-select /thank-you and inline booking endpoints | Prevent Auto Ads inside conversion flow pages. |

Implementation details
- Add page-level attributes: `data-ads-type="transfer-detail"` and `data-booking-sensitive="true/false"`. Auto Ads and ad-renderers should read these flags.
- Keep Anchor and Vignette OFF for pages with `booking_sensitive=true`.

---

## 3) Conversion‑safe suppression zones — exact rules

Implement server-side flags and client-side checks. Server-side suppression is preferred (faster, reliable).

A. Template / server flag
- `booking_sensitive = true` set for detail pages with visible booking widget, price badge, calendar/pax selectors or immediate Book CTA. All ad code *must* check this flag.

B. Spatial suppression rules (enforceable)
- Do not render any ad-slot whose top edge is within **350px vertical distance** of `.price-card`, `#booking-form`, or `.book-cta`.
- `price-ad-guard` is a reserved block adjacent to price where **no ad may render**.
- Do not render `hero-banner` if it pushes the price/CTA below the fold.
- On mobile always hide `sidebar-1`.

C. Session & referral suppression
- If visitor arrives with `utm_medium=cpc` and `utm_campaign` indicates booking intent (contains BOOK/BOOKING), suppress in-article and in-feed ads for that session (30–60 minutes) to preserve conversion focus.
- If user clicks Book CTA, keep ads suppressed for the remainder of the session across listing/detail/checkout pages.

D. Checkout/payment pages
- Server-side block: do not serve ads on `/booking`, `/checkout`, `/payment`, `/seat-select`, `/thank-you`.

E. Lazy-load behavior
- Only request ad creatives when slot is within **400px** of the viewport (IntersectionObserver). Above-the-fold ad slots may load immediately but must pass distance checks.

Developer checklist (priority)
1. Add `booking_sensitive` to template context.  
2. Server-side placement decisions before returning HTML; fallback to client-side distance check.  
3. Use IntersectionObserver with 400px pre-load threshold.  
4. Persist session suppression flag for paid visitors (sessionStorage or first-party cookie).

---

## 4) Policy checklist — must follow

Placement & UX
- Never place ads inside, overlaying, or visually mimicking price, availability, seat selection, or Book CTA.  
- Anchor/sticky ads: OFF where they can obscure or be mistaken for booking controls.  
- No interstitials on booking flows.

Affiliate & widget compliance
- If embedding third‑party booking widgets or affiliate flows:
  - Parent page must contain primary content (not an ad shell).  
  - Disclose affiliate relationship near the CTA (example: “Partner booking. Commission may apply”).  
  - Do not allow iframe widgets to render ads inside the iframe; ads must be outside widget bounds.

Content & image rights
- Use licensed or owned images only. Avoid graphic or dangerous imagery without safety disclaimers.

Privacy & consent
- Comply with GDPR/CCPA: do not serve personalized ads before required consent in applicable regions.  
- Ensure privacy policy is accessible.

Invalid traffic & click safety
- Monitor for CTR spikes and low conversion patterns; treat as potential accidental clicks and pause placements for investigation.  
- Implement alerts for abnormal CTR or revenue spikes on booking pages.

Logging & auditing
- Log which ad slots were served together with `booking_sensitive` and session source to analyze impact on conversions.

---

## 5) 7‑Day Test Plan with KPI targets

Objective: safely monetize transfer detail pages while preserving booking conversions.

Test design: Randomized A/B split 50/50
- Control (A): current page (minimal/no ads on detail page).
- Test (B): implement `inline-1`, `post-content-1`, `sidebar-1` (desktop). `hero-banner` optional only on non-booking-sensitive pages. Enforce suppression rules. Auto in-article allowed per rule; anchor/vignette OFF.

Sample size & duration
- Run for **7 days** or until minimum **3,000 detail pageviews per variant** (adjust to traffic).

Metrics to capture daily
- Detail pageviews  
- Book CTA Click-Through Rate (Book CTR)  
- Booking conversion rate (CVR) from detail page sessions  
- Page RPM (AdSense)  
- Ad CTR (per-slot)  
- CLS & LCP  
- Bounce rate and session duration

KPI table — baseline vs targets & action thresholds

| KPI | Baseline | Test target | Immediate action threshold |
|---|---:|---:|---|
| Book CTR | baseline | No decrease >4% relative | If drop >4% pause Test B |
| Booking CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental-click patterns | If CTR spikes + low conversions pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholders and defer ad load |
| LCP (mobile) | baseline | ≤+15% increase | If >+15% optimize images/defer ads |
| Bounce rate | baseline | No increase >7% | If increase >7% investigate ad interference |

Day-by-day execution
- Day 0: Implement ad placeholders with reserved CSS heights; add `booking_sensitive` flag; implement server-side ad placement and session suppression. Configure GTM A/B split and GA4 events: `transfer_detail_view`, `book_cta_click`, `booking_started`, `booking_confirmed`.
- Day 1 (launch): Start 50/50 split. Monitor hourly for first 6–8 hours for JS errors, ad disapprovals, and CTR anomalies.
- Days 2–3: Daily reviews. If Book CTR or CVR shows >3% negative trend, reduce density (remove `sidebar-1` or move `inline-1` further down).
- Day 4: Mid-test adjustments.
- Days 5–6: Stabilize placements or further reduce density if needed.
- Day 7: Analyze results. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and iterate with lighter density.

Deliverable after test
- One‑page report: RPM delta, Book CTR delta, CVR delta, per-slot performance, CLS/LCP deltas and recommended steady-state configuration.

---

## Quick developer handoff snippets

CSS reserved placeholders
```css
.ad-inline-1 { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
.ad-hero-banner { width:100%; min-height:90px; }
.price-ad-guard { min-width:200px; min-height:80px; /* reserved non-ad zone */ }
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
  // session suppression for paid visitors
  if (location.search.includes('utm_medium=cpc') && location.search.includes('BOOK')) {
    sessionStorage.setItem('ads_suppressed','1');
  }
  if (sessionStorage.getItem('ads_suppressed') === '1') {
    document.querySelectorAll('.in-article-ad').forEach(a=>a.style.display='none');
  }
}
```

GTM / GA4 events to implement
- `transfer_detail_view` (page load)  
- `book_cta_click` (click)  
- `booking_started` (form submit)  
- `booking_confirmed` (thank-you page)

Logging
- Include per-page metadata in ad logs: page_type, category, booking_sensitive flag, session_source (utm tags), variant (A/B).

---

If you want I can:
- Produce ready-to-paste HTML/CSS ad-slot snippets for every block and the suppression JS.
- Export GTM container JSON for the A/B split and GA4 event tags for direct import.
- Create a GA4 dashboard spec (chart list and filters) to monitor the KPIs during the 7‑day test.

Which artifact would you like next?
