# AdSense Implementation Plan — Car Rental (Listing Page)  
Site: https://balitatittour.com  
Page: Car rental listing (multiple car options, prices, availability, pick‑up/drop‑off, Book/Reserve CTAs)

Implementation‑ready plan developers and monetization owners can drop into templates. Goal: monetize listing inventory while protecting price clarity, booking CTAs and UX.

---

## 1) Placements — block names, sizes, positions & rules

Use these block names in templates and logs for traceability.

| Block name | Position (desktop / mobile) | Recommended sizes | Density / Rules |
|---|---:|---:|---|
| listing-infeed-1 | In‑feed: between item 3 and 4 (desktop & mobile) | Responsive 300×250 | 1 per 6–8 items; lazy‑load when near viewport |
| listing-infeed-2 | In‑feed: mid list after item 10 | Responsive 300×250 | Optional 1 per page max; avoid clustering |
| top-banner | Above results under header (desktop only) | 728×90 / responsive | Desktop only; only if first result remains above fold |
| sidebar-1 | Right rail near filters/results (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile |
| mobile-inline-small | Mobile small in‑feed (after second card) | 320×100 responsive | 1 per 6 items; ensure not adjacent to price or book CTA |
| post-listing-1 | Below listing and pagination | 300×250 responsive | Lazy‑load at end of page |
| sticky-anchor | Mobile sticky footer | 320×50 | Not recommended on listing pages with visible Book buttons; if used, hide for high intent sessions |
| comparison-guard | Reserved non-ad block adjacent to price comparisons | N/A | No ads allowed here; prevents confusion with price/CTA |

Practical caps:
- Desktop: ≤2 ads visible above the fold.
- Mobile: ≤1 ad visible above the fold.

Implementation notes:
- Do not place ads inside card DOM or next to interactive selectors (dates, times, pax).
- Reserve CSS heights to avoid CLS (see suppression & test sections).

---

## 2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Listing page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON | Good complement to manual in‑feed units when controlled. |
| In‑article | ON | OFF | Listing pages are not long-form articles; in-article may misplace units. |
| In‑feed / Matched content | ON if eligible | ON (controlled density) | Matches listing structure; enforce frequency limits. |
| Anchor (sticky) | OFF | OFF for booking-sensitive listing pages | Sticky can be mistaken for booking controls. |
| Vignette / Interstitial | OFF | OFF | Disruptive to selection and booking process. |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /payment /seat-select /thank-you and detail pages with inline booking widgets | Prevent auto placements on transactional pages. |

Action:
- Enable Auto Display and In‑feed globally, but enforce per-page `data-ads-layout="listing"` and server-side suppression logic to prevent placements near CTAs.
- Keep Anchor and Vignette OFF for all listing pages with immediate Book buttons.

---

## 3) Conversion‑safe suppression zones — exact rules

A. Template / server flag
- `listing_sensitive = true` when cards include immediate `.price` and `.book-cta` or inline booking selectors. All ad-renderers must check this flag before injecting slots.

B. Spatial & adjacency rules (enforceable)
- Do **not** render any ad-slot whose top edge is within **300px vertical** of any `.book-cta`, `.price`, date selector, or interactive UI.
- Do **not** insert `listing-infeed-1` within the same parent as a card containing `.book-cta`.
- Maintain at least **2-cards** separation between an in‑feed ad and the nearest card with an active booking CTA.
- Do not show `top-banner` if it pushes price/CTA out of the initial viewport.

C. Session & referral suppression
- If user arrives via paid campaign with `utm_medium=cpc` and `utm_campaign` contains BOOK/RENT, set session suppression: **suppress in‑feed ads** for that session or until booking completes (30–60 minutes).
- If user clicks a Book CTA, persist suppression for remainder of session.

D. Filter/control area safety
- Do **not** place ads adjacent to filter panels, date/time selectors, or sort controls.

E. Pagination behavior
- Avoid repeating same ad creative on page 1 and page 2 for same session to prevent fatigue/accidental clicks.

Developer checklist
1. Add `listing_sensitive` to template context and log in ad events.  
2. Prefer server-side placement logic; fallback to client-side distance checks before ad requests.  
3. Lazy-load ad slots with IntersectionObserver (threshold ~400px).  
4. Store session suppression flag in sessionStorage or first-party cookie for paid visitors.

---

## 4) Policy checklist — must follow for listing pages

Placement & UX
- Ads must never mimic price tags, booking buttons, or site navigation.  
- No ads inside card DOM or overlapping interactive widgets.  
- Anchor/sticky ads disabled for listing pages with Book CTAs.

Affiliate & widget compliance
- If listings include third‑party booking or aggregator widgets:
  - Display clear disclosure near CTA: “Partner booking. Commission may apply.”  
  - Do not allow affiliate iframe to display ads inside iframe. Ads must be outside widget boundaries.  
  - Ensure prices and availability are accurate and not obfuscated by ads.

Content & image rights
- Use owned or licensed images. Do not display copyrighted imagery without permission.  
- Moderate UGC (reviews) to remove PII or copyrighted excerpts.

Privacy & consent
- Respect GDPR/CCPA: do not show personalized ads before consent in required regions.  
- Ensure privacy policy link present and consent prompt does not block booking controls.

Invalid traffic & click safety
- Monitor CTR for anomalies. Sudden high CTR with low conversions could indicate accidental clicks; pause placements and investigate.

Logging & audit
- Log per-session which ad slots served along with `listing_sensitive` and session source to analyze correlation with bookings.

---

## 5) 7‑Day Test Plan with KPI targets

Objective: validate in-feed monetization on car rental listing pages while protecting bookings.

Test design: A/B split (50/50)
- Control (A): current listing page (Auto ads only or minimal manual units).
- Test (B): implement `listing-infeed-1` and optional `listing-infeed-2` + `sidebar-1` (desktop). Auto In‑feed ON. Enforce suppression rules.

Duration & sample size
- 7 days or until **≥6,000 listing pageviews per variant** (adjust to actual traffic).

Metrics to capture daily
- Listing pageviews  
- Card Book CTA Click‑Through Rate (Book CTR)  
- Booking conversion rate (CVR) from listing sessions  
- Page RPM (AdSense)  
- Ad CTR (per-slot)  
- CLS & LCP  
- Bounce rate and session duration

KPI targets & action thresholds

| KPI | Baseline | Test target | Immediate action threshold |
|---|---:|---:|---|
| Card Book CTR | baseline | No decrease >4% relative | If drop >4% pause Test B |
| Booking CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental click spikes | If CTR spikes & conversions low pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholders/defer ads |
| LCP (mobile) | baseline | ≤+15% overhead | If >+15% optimize assets/defer ads |
| Bounce rate | baseline | No increase >7% | If increase >7% investigate ad interference |

Day-by-day execution
- **Day 0**: Implement ad placeholders with reserved heights; set `listing_sensitive` flag; server-side ad insertion ensuring separation; configure GTM for A/B split and GA4 events: `listing_view`, `card_book_click`, `booking_started`, `booking_confirmed`.
- **Day 1 (launch)**: Start 50/50 split. Monitor hourly first 6–8 hours for JS errors, ad disapprovals, CTR anomalies.
- **Day 2–3**: Review daily metrics. If Book CTR or CVR declines >3% trend, reduce density (remove listing-infeed-2 or sidebar-1).
- **Day 4**: Mid-test adjustment if needed.
- **Day 6**: Stabilize placements or further reduce density if required.
- **Day 7**: Analyze outcomes. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and iterate with lower density or alternate placements.

Reporting deliverable
- Final report: RPM delta, Book CTR delta, CVR delta, per-slot CTR, CLS/LCP deltas, recommended steady-state configuration.

---

## Developer handoff snippets

CSS placeholders
```css
.ad-listing-infeed { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
[data-listing-sensitive="true"] .ad-top-banner { display:none !important; }
```

Server-side insertion pseudo
```py
positions=[]
for i, card in enumerate(cards):
  if i>2 and i%6==3 and not card.has_booking_cta:
    positions.append(i)
```

Session suppression pseudo
```js
if (location.search.includes('utm_medium=cpc') && location.search.includes('BOOK')) {
  sessionStorage.setItem('ads_suppressed','1');
}
if (sessionStorage.getItem('ads_suppressed')==='1') hideInfeedAds();
```

GTM / GA4 events to implement
- `car_listing_view`  
- `card_book_click`  
- `booking_started`  
- `booking_confirmed`

Logging
- Include: page_type, category, `listing_sensitive`, session_source, ad_slots_served in ad logs for post-test analysis.

---

Would you like:
- Ready-to-paste HTML/CSS ad-slot snippets for listing-infeed and sidebar with aria labels?  
- GTM container JSON for A/B split + GA4 event tags for direct import?  
- GA4 dashboard spec (charts and filters) to monitor KPIs during the 7‑day test?

Which artifact should I prepare next?
