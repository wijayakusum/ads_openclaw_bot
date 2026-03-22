# AdSense Implementation Plan — Hotel Package Stay (Listing Page)  
Site: https://balitatittour.com  
Page: Hotel package listing (multiple hotel packages, prices, filters, Book or Select room CTAs)

Implementation‑ready guidance for developers, product owners and monetization teams. Focus: monetize listings while protecting price clarity and booking conversions.

---

## 1) Placements — block names, sizes, position & rules

| Block name | Position | Recommended sizes | Density / Visibility rule |
|---|---:|---:|---|
| top-banner | Under header above filters/results (desktop only) | 728×90 or responsive | Desktop only. Show only if header and first results remain above fold. |
| listing-infeed-1 | In-feed: between item 3 and 4 (mobile & desktop) | Responsive 300×250 | 1 per 6–8 items; lazy‑load when near viewport |
| listing-infeed-2 | In-feed: mid-list after item 10 | Responsive 300×250 | Optional 1 per page max; avoid clustering |
| sidebar-1 | Right rail beside filters/results (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile |
| mobile-inline | Mobile in-feed small slot (after second card) | 320×100 responsive | 1 per 6 items; do not be adjacent to price or booking CTA |
| post-listing-1 | Below listing and pagination | 300×250 responsive | Lazy‑load after scroll to bottom |
| sticky-anchor | Mobile sticky footer ad | 320×50 | Not recommended on pages where booking is immediate; can be tested on pure editorial listing hubs |

Notes:
- Above-the-fold ad caps: Desktop ≤2 visible ads; Mobile ≤1 visible ad.
- Do not place ad units within card elements or inside price/CTA containers.

---

## 2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Listing page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON | Good complement to manual in-feed units |
| In-article | ON | OFF | Listing page is not long-form content; in-article may misplace units |
| In-feed / Matched content | ON if eligible | ON (controlled density) | Works well with listing feeds; limit frequency |
| Anchor (sticky) | OFF | OFF for booking-heavy listings | Avoid accidental clicks on CTAs |
| Vignette / Interstitial | OFF | OFF | Disruptive to selection and booking flow |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /payment /thank-you and detail pages with seat selectors | Keep transactional pages ad-free |

Action:
- Enable Auto Display and In‑feed globally, but enforce per-page data flag (e.g., data-ads-layout="listing") and server-side suppression to prevent ads near booking controls.

---

## 3) Conversion‑safe suppression zones — exact rules

A. Template / server flags
- `listing_sensitive = true` when cards include immediate prices and Book CTAs or inline booking widgets.
- Ad rendering must respect this flag.

B. Spatial & adjacency rules
- Never render ads inside card DOM elements or within the same parent as `.price`, `.book-cta`, or date selector controls.
- Minimum separation: at least 2 cards between inserted in‑feed ad slot and nearest card containing booking CTA.
- Do not place top-banner if it pushes first card with important price/CTA below fold.

C. Session & referral suppression
- If user arrives via paid campaign (`utm_medium=cpc` with booking intent) suppress in‑feed ads for that session (30–60 minutes) to protect conversion focus.
- If user clicks a card’s Book CTA, suppress further ad loads in that session.

D. Filter and control area
- Do not place ads adjacent to filters, sort, or calendar controls. These are interaction zones.

E. Pagination and repeated creatives
- Avoid repeating the same ad creative across paginated pages in a single session to reduce fatigue and accidental clicks.

Developer checklist
1. Add `listing_sensitive` server flag to template.  
2. Compute and insert ad slots server-side with separation rules.  
3. Use IntersectionObserver to lazy-load ad slots only when within 400px of viewport.  
4. Use session cookie for paid referral suppression.

---

## 4) Policy checklist — compliance & must-avoid items

Placement & UX
- Ads must not mimic price info, booking buttons, or navigational elements.
- No ads inside or overlaying price or booking CTA containers.
- Anchor/sticky ads should be disabled for booking-heavy listing pages.

Affiliate & widget compliance
- If integrating third‑party booking widgets or affiliate offers:
  - Provide clear disclosure near CTA (e.g., “Partner booking. Commission may apply”).
  - Do not allow third‑party iframes to display ads; parent page only.
  - Ensure availability and price info is accurate and not overridden by ad placements.

Content and moderation
- Prices must be accurate and updated; do not place ads that might be confused with price content.
- Moderate UGC (reviews) to remove PII and copyrighted content.

Privacy & consent
- Respect GDPR/CCPA. Do not serve personalized ads before consent. Ensure privacy policy link visible.

Invalid traffic & click safety
- Monitor for CTR anomalies on listing pages. High CTR with low conversion suggests accidental clicks; pause placements and investigate.

---

## 5) 7‑Day Test Plan with KPI targets

Objective: monetize hotel listing pages without harming booking behavior.

Test design: A/B split (50/50)
- Control (A): Current listing page with minimal or Auto ads only.
- Test (B): Manual in‑feed placements (`listing-infeed-1`), optional `listing-infeed-2` (midlist), `sidebar-1` (desktop). Auto In‑feed ON. Enforce suppression rules.

Sample size & duration
- 7 days or until ≥8,000 listing page views per variant.

Metrics to track daily
- Listing pageviews
- Card Book CTA Click‑Through Rate (Book CTR)
- Booking conversion rate (CVR) from listing sessions
- Page RPM (AdSense)
- Ad CTR (per-slot)
- CLS & LCP
- Bounce rate and session duration

KPI table: baseline vs targets & action thresholds

| KPI | Baseline | Test target | Action threshold |
|---|---:|---:|---|
| Card Book CTR | baseline | No decrease >5% relative | If drop >5% pause Test B |
| Booking CVR | baseline | No decrease >6% relative | If drop >6% revert |
| Page RPM | baseline | +25% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental click spikes | If CTR spikes and conversions low pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholders immediately |
| LCP (mobile) | baseline | ≤+15% increase | If >+15% optimize media/defer ads |
| Bounce rate | baseline | Not increase >7% | If increase >7% investigate ad interference |

Day-by-day execution
- **Day 0**: Implement ad placeholders with reserved CSS heights; set `listing_sensitive` flag; implement server-side ad insertion and session suppression for paid visitors; configure GTM for A/B split and GA4 events (`listing_view`, `card_book_click`, `booking_started`, `booking_confirmed`).
- **Day 1 (launch)**: Start 50/50. Monitor hourly for first 6–8 hours for errors and CTR anomalies.
- **Days 2–3**: Check daily trends; if Book CTR or CVR declines >3% trend, reduce density (remove `listing-infeed-2` or `sidebar-1`).
- **Day 4**: Mid-test adjustments based on data.
- **Day 6**: Final adjustments.
- **Day 7**: Evaluate; accept Test B if CVR drop ≤6% and RPM uplift ≥25%. Otherwise revert and iterate with lower density.

Reporting deliverable
- Post-test summary: RPM delta, Book CTR delta, CVR delta, per-slot CTR, CLS/LCP deltas, recommended steady-state configuration.

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
# place ad after card index 3 and after index 10 with minimum separation check
insert_positions=[]
for i, card in enumerate(cards):
  if i>2 and i%6==3 and not card.has_booking_cta:
    insert_positions.append(i)
```

Session suppression pseudo
```js
if (location.search.includes('utm_medium=cpc') && location.search.includes('BOOK')) {
  sessionStorage.setItem('ads_suppressed','1');
}
if (sessionStorage.getItem('ads_suppressed')==='1') {
  hideInfeedAds();
}
```

GTM events to create
- `listing_view`
- `card_book_click`
- `booking_started`
- `booking_confirmed`

---

Would you like:
- Ready-to-paste HTML/CSS for in‑feed placeholders and server insertion function, or
- A GA4 dashboard spec to monitor KPIs during the 7‑day test?

Which next artifact should I prepare?
