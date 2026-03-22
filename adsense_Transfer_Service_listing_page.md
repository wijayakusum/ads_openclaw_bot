# AdSense Implementation Plan — Transfer Service (Listing Page)  
Site: https://balitatittour.com  
Page: Transfer service listing (multiple transfer options, prices, pickup times, Book/Reserve CTAs)

Implementation‑ready guidance. Objective: monetize listing inventory while protecting booking interactions and clear price/availability UI.

---

## 1) Placements — block names, sizes, position & rules

| Block name | Position | Recommended sizes | Density / Rules |
|---|---:|---:|---|
| listing-infeed-1 | In‑feed: between items 3 and 4 (mobile & desktop) | Responsive 300×250 | 1 per 6–8 items; lazy‑load when near viewport |
| listing-infeed-2 | In‑feed: mid-list after item 10 | Responsive 300×250 | Optional; max 1 per page; avoid clustering |
| top-banner | Above results under header (desktop only) | 728×90 / responsive | Desktop only; show only if first results remain above fold |
| sidebar-1 | Right rail next to filters/results (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile |
| mobile-inline-small | Mobile compact in-feed (after second card) | 320×100 responsive | 1 per 6 items; ensure not adjacent to price or Book CTA |
| post-listing-1 | Below listings / pagination | 300×250 responsive | Lazy‑load at page end |
| sticky-anchor | Mobile sticky footer | 320×50 | Not recommended on listing pages with visible Book buttons; optional on editorial hubs |

Notes:
- Do not place ads inside card DOM or next to interactive controls (date/time/pax selectors).
- Cap above-fold ads: Desktop ≤2; Mobile ≤1.

---

## 2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Listing page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON | Good complement to manual in‑feed units. |
| In-article | ON | OFF | Listing pages are structured lists not long articles. |
| In‑feed / Matched content | ON if eligible | ON (controlled density) | Matches listing feed; limit frequency. |
| Anchor (sticky) | OFF | OFF (recommended) | Prevent accidental clicks on booking CTAs. |
| Vignette / Interstitial | OFF | OFF | Disruptive to selection/booking flow. |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /payment /thank-you and any detail pages that allow seat/vehicle selection | Keep conversion flow ad-free. |

Action:
- Use page-level attribute (e.g., `data-ads-layout="listing"`) so Auto Ads respects placement rules and suppression zones.
- Keep anchor & vignette OFF for listing pages with booking CTAs.

---

## 3) Conversion‑safe suppression zones — exact rules

A. Template flag
- `listing_sensitive = true` when cards show immediate price + Book CTA or inline selectors. Ad logic must check this flag.

B. Spatial/adjacency rules
- Do NOT render any ad-slot within **300px vertical** distance of any `.book-cta`, `.price`, or interactive selector.
- Do NOT insert `listing-infeed-1` inside or within the same parent element as a card containing `.book-cta`.
- Maintain at least two cards separation between an in‑feed ad and the nearest card with an active booking CTA.

C. Session & referral suppression
- If user arrives with `utm_medium=cpc` and campaign indicates booking intent, suppress in‑feed units for the session (30–60 minutes) to preserve conversion focus.
- If user clicks a Book CTA, suppress further ads in that session across listing/detail/checkout flow.

D. Filter & control area safety
- Do not place ads adjacent to filter panels, date/time selectors, or sort controls.

E. Pagination & repeated exposure
- Avoid repeating the same ad creative on page 1 and page 2 within the same session.

Developer checklist
1. Server-side compute ad insertion points ensuring separation rules.  
2. Add `listing_sensitive` flag to template.  
3. Use IntersectionObserver to lazy-load only when ad-slot is within 400px of viewport.  
4. Use session storage cookie for paid/referral suppression.

---

## 4) Policy checklist — must follow

Placement & UX
- No ads that mimic Book buttons, price tags, or site navigation.  
- No ads inside card elements or overlapping interactive controls.  
- No anchor or interstitial ads that obscure CTAs.

Affiliate & widget compliance
- For third‑party booking widgets or affiliates:
  - Disclose affiliate relationship near CTA (e.g., “Partner booking. Commission may apply”).  
  - Do not allow affiliate iframe to render ads; parent page only.  
  - Ensure price and availability accuracy.

Content moderation & rights
- Use licensed images; avoid misleading or unsafe imagery.  
- Moderate UGC for profanity, personal data, or copyright issues.

Privacy & consent
- Respect GDPR/CCPA: do not serve personalized ads before required consent.  
- Ensure visible privacy policy.

Invalid traffic & click safety
- Monitor CTR anomalies; high CTR + low conversions → potential accidental clicks. Pause placements and investigate.

Logging & auditing
- Log per-session which ad slots were served and page flags for later analysis.

---

## 5) 7‑Day Test Plan with KPI targets

Objective: validate in‑feed monetization on transfer listing pages with minimal impact on booking conversions.

Test design: A/B split 50/50
- Control (A): current page (Auto ads or minimal units).
- Test (B): implement `listing-infeed-1` and optional `listing-infeed-2` + `sidebar-1` (desktop) with suppression rules active. Auto In‑feed ON.

Duration & sample size
- 7 days or until **≥6,000 listing pageviews per variant**.

Metrics to capture daily
- Listing pageviews
- Card Book CTA Click-Through Rate (Book CTR)
- Booking conversion rate (CVR) from listing sessions
- Page RPM (AdSense)
- Ad CTR (per-slot)
- CLS & LCP
- Bounce rate and session duration

KPI targets & action thresholds

| KPI | Baseline | Test target | Action threshold |
|---|---:|---:|---|
| Card Book CTR | baseline | No decrease >4% relative | If drop >4% pause Test B |
| Booking CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental click spikes | If CTR spikes with low conversions pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholders and defer loads |
| LCP (mobile) | baseline | ≤+15% increase | If >+15% optimize assets or defer ads |
| Bounce rate | baseline | No increase >7% | If >7% inspect ad interference |

Day-by-day execution
- **Day 0**: Implement ad placeholders, `listing_sensitive` flag, server-side ad insertion and session suppression. Configure GTM A/B split and GA4 events: `listing_view`, `card_book_click`, `booking_started`, `booking_confirmed`.
- **Day 1 (launch)**: Start 50/50 split. Monitor hourly first 6–8 hours for errors and CTR anomalies.
- **Days 2–3**: Daily reviews. If Book CTR or CVR declines >3% trending, reduce density (remove `listing-infeed-2` or sidebar).
- **Day 4**: Mid-test adjustments.  
- **Days 5–6**: Stabilize placements or reduce density if needed.  
- **Day 7**: Final analysis. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and iterate.

Deliverables after test
- Summary: RPM delta, Book CTR delta, CVR delta, per-slot CTR, CLS/LCP deltas, recommendation (Keep / Reduce / Re-test).

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
# ensure minimum separation of 2 cards between ads
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

GTM events to implement
- `transfer_listing_view`
- `card_book_click`
- `booking_started`
- `booking_confirmed`

---

If you want I can:
- Produce ready-to-paste HTML/CSS for listing-infeed and sidebar ad slots.
- Generate GTM container JSON for the A/B split and GA4 event tags.
- Create the GA4 dashboard spec to monitor KPIs during the 7‑day test.

Which artifact would you like next?
