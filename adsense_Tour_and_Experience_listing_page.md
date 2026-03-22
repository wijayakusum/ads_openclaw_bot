# AdSense Implementation Plan — Category: Tour and Experience (Listing Page)  
Site: https://balitatittour.com  
Page: Tour & Experience listing (multiple tour cards, filters, sort)

Practical, implementation‑ready guidance for devs/ops. Goal: monetize listing inventory while protecting booking/CTA conversions and UX.

---

1) Placements — block names, sizes, position & rules

| Block name | Position | Recommended sizes | Allowed density & rules |
|---|---|---:|---|
| listing-infeed-1 | In‑feed: between items 3 and 4 (mobile & desktop) | Responsive 300×250 | 1 per 6–8 items; lazy‑load when near viewport |
| listing-infeed-2 | In‑feed: mid list after item 10 | Responsive 300×250 | 1 per page max (avoid clustering) |
| top-banner | Above results under header (desktop only) | 728×90 / responsive | Desktop only; show only if primary filters remain visible |
| sidebar-1 | Right rail next to filters/results (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile |
| mobile-inline-small | Mobile small in-feed (after second card) | 320×100 responsive | 1 per 6 items; ensure not adjacent to booking CTA |
| post-listing-1 | Below list / pagination | 300×250 responsive | Lazy-load at end of page |
| sticky-anchor | Mobile sticky footer ad | 320×50 | NOT recommended on listing pages with visible booking CTAs; use cautiously and hide for paid visitors |

Implementation notes:
- Mobile: prefer single in‑feed ad above the fold only if it doesn’t push first result below fold.
- Avoid placing in-feed ads inside cards or within the same DOM element as Tour CTA buttons.

---

2) Auto Ads: ON / OFF settings (global + per-page)

| Auto Ad format | Global default | Listing page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON | Good complement to manual in‑feed units |
| In‑article | ON | OFF | Listing pages are not long‑form articles; in‑article can misplace units |
| In‑feed | ON if eligible | ON | Matches listing structure; limit density and positions |
| Matched content | ON if eligible | ON for high traffic listing hubs | Use only where engagement warrants |
| Anchor (sticky) | OFF | OFF for listing pages with booking CTAs | Avoid accidental clicks and obscuring CTAs |
| Vignette / Interstitial | OFF | OFF | Disruptive for selection/booking flows |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /thank-you and any detail pages containing seat selectors | Keeps checkout/booking ad-free |

Action:
- Keep Auto Display and In‑feed enabled globally; enforce page-level data attribute (data-ads-layout="listing") to control injection and respect suppression rules.

---

3) Conversion‑safe suppression zones — exact rules

A. Template/server flags
- listing_sensitive = true if the listing page combines immediate booking CTAs or price selectors on-card.
- For listing_sensitive true, enforce server-side suppression of top-banner and any ad within 250–300px proximity of item CTAs.

B. Spatial & adjacency rules
- Do not insert an in‑feed ad inside a card or within the same parent element as a .book-cta or .price element.
- Minimum separation: at least 2 listing cards between any ad and the nearest card containing an active booking CTA.

C. Session & referral rules
- If visitor arrives with utm_medium=cpc and utm_campaign includes BOOK or similar high intent, suppress in‑feed ads for that session (30 minutes) to protect conversion focus.
- If user interacts with any list item “Book” CTA, suppress further ads in that session.

D. Filter/Control area safety
- Do not place ads adjacent to filter controls, sort dropdowns, or date selectors—these are critical interaction zones.

E. Pagination & repeated exposure
- Avoid repeating same ad creative on subsequent paginated pages during a single session.

Developer implementation checklist (short)
1. Add listing_sensitive flag in template context.  
2. Compute ad insertion points server-side to ensure card separation.  
3. Use IntersectionObserver to lazy-load ad slots only when near viewport.  
4. Implement session cookie for paid/referral visitor suppression.

---

4) Policy checklist — what to avoid and compliance notes

Placement & UX
- No ads that mimic booking CTAs or price tags.
- No ads inside card elements or adjacent to in-card CTAs.
- Anchor and interstitial ads should be OFF on listing pages that directly lead to booking.

Affiliate & widget compliance
- If listings pull third-party affiliate offers:
  - Disclose affiliate relationship on page (e.g., “Partner offer may include commission”).
  - Ensure affiliate iframes do not render ads inside their frames.
  - Parent page must contain primary content, not only an ad shell.

Content accuracy and moderation
- Prices and availability shown in cards must be accurate; do not place ads that could be confused with price content.
- Moderate UGC (reviews/comments) to remove PII and copyrighted content.

Privacy & consent
- Respect regional consent rules; do not serve personalized ads before explicit consent in required regions.
- Keep privacy policy link visible on listing page (footer).

Invalid traffic and click safety
- Monitor for CTR anomalies, especially on mobile in‑feed units. Use thresholds and automatic pause rules.

---

5) 7‑Day Test Plan with KPI targets

Objective: Validate in‑feed monetization with minimal impact on booking CTR and conversions.

Test design: A/B split 50/50
- Control (A): current listing page with Auto Ads only or minimal manual ad units.
- Test (B): manual in‑feed units (listing-infeed-1), optional sidebar-1 (desktop), Auto In‑feed ON, suppression flags active.

Duration & minimum volume
- 7 days or until minimum 8,000 listing page views per variant.

Metrics to track (daily)
- Listing pageviews
- Card Book CTA Click-Through Rate (Book CTR)
- Booking conversion rate (CVR) originating from listing page
- Page RPM (AdSense)
- Ad CTR (per-slot)
- CLS & LCP
- Bounce rate

KPI targets and thresholds

| KPI | Baseline | Test target | Action threshold |
|---|---:|---:|---|
| Card Book CTR | baseline | No decrease >5% relative | If drop >5% pause Test B immediately |
| Booking CVR (from listing sessions) | baseline | No decrease >6% relative | If drop >6% revert or reduce density |
| Page RPM | baseline | +25% uplift desirable | If RPM uplift <10% and CVR drops >2% revert |
| Ad CTR | baseline | Monitor for accidental click spikes | If CTR spikes with low conversion, pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 immediately reduce dynamic placements |
| LCP (mobile) | baseline | ≤+15% increase | If >+15% optimize images/defer ads |

Day-by-day plan
- Day 0: Implement manual in‑feed placeholders and reserved heights; set listing_sensitive flag; implement server-side ad placement logic and GTM A/B split; ensure GA4 events for book_cta_click and booking_confirm.
- Day 1 (launch): Start 50/50. Monitor first 6–8 hours for JS errors, ad disapprovals, CTR spikes.
- Day 2–3: Watch daily trends. If Card Book CTR drops >3% trend, reduce density (remove listing-infeed-2 or sidebar-1).
- Day 4: Mid-test adjust based on data.
- Day 6: Final adjustments.
- Day 7: Analyze outcomes — accept if RPM uplift ≥25% with CVR decline ≤6%; otherwise iterate with lower density/alternate placement.

Reporting deliverable
- Comparison table of baseline vs test B: RPM, Book CTR, CVR, CLS, LCP.
- Recommendation: which placements to keep, which to remove, next test iteration.

---

Developer handoff snippets (quick)

CSS reserve example
```css
.ad-listing-infeed { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
[data-listing-sensitive="true"] .ad-top-banner { display:none !important; }
```

Server-side insertion logic (pseudo)
```py
# ensure minimum separation of 2 cards between ads
insert_positions = []
for i, card in enumerate(cards):
  if i > 2 and i % 6 == 3 and not nearCTA(card):
    insert_positions.append(i)
```

Session suppression pseudo
```js
if (utm_medium === 'cpc' && utm_campaign.includes('BOOK')) {
  sessionStorage.setItem('ads_suppressed', '1');
}
if (sessionStorage.getItem('ads_suppressed') === '1') {
  hideAllInfeedAds();
}
```

GTM events to implement
- listing_page_view
- card_book_cta_click
- booking_started
- booking_confirmed

---

Would you like:
- Ready-to-paste HTML for in-feed placeholders and sample server-side insert function?  
- GA4 dashboard spec showing the exact reports to monitor during the 7‑day test?

Which one should I prepare next?
