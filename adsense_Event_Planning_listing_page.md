# AdSense Implementation Plan — Event Planning (Listing Page)  
Site: https://balitatittour.com  
Page: Event planning listing (multiple event planners / packages / venue options, prices, availability, contact/quote CTAs)

Implementation‑ready plan developers and monetization owners can apply. Goal: monetize listing inventory while protecting contact/quote conversions and preserving clear price/venue info.

---

## 1) Placements — block names, sizes, positions & rules

Use canonical block names in templates and logs for consistent monitoring.

| Block name | Position (desktop / mobile) | Sizes (recommended) | Density / Rules |
|---|---:|---:|---|
| top-banner | Under header above filters/results (desktop only) | 728×90 or responsive | Desktop only; show only if results header still visible above fold |
| listing-infeed-1 | In‑feed: between items 3 and 4 (desktop & mobile) | 300×250 responsive | 1 per 6–8 items; lazy‑load when near viewport |
| listing-infeed-2 | In‑feed: mid list after item ~10 | 300×250 responsive | Optional 1 per page; avoid clustering |
| sidebar-1 | Right rail next to filters/results (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile |
| mobile-inline-small | Mobile small in‑feed (after second card) | 320×100 responsive | 1 per 6 items; do not appear adjacent to contact/quote CTA |
| post-listing-1 | Below listings / pagination | 300×250 responsive | Lazy‑load at end of page |
| sticky-anchor | Mobile sticky footer | 320×50 | Not recommended when quote/contact CTAs visible; use only on editorial hubs and with close button |
| contact-guard | Reserved no-ad block around contact/quote CTA and price area | N/A (non-ad zone) | No ads allowed here — prevent confusion with CTAs |

Practical caps:
- Desktop: ≤2 ads visible above-the-fold.
- Mobile: ≤1 ad visible above-the-fold.

Notes:
- Do not place ads inside listing cards or next to interactive controls (date pickers, quote buttons).
- Reserve CSS heights for all ad slots to prevent CLS.

---

## 2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Listing page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON | Good complement to manual in‑feed units when controlled. |
| In‑article | ON | OFF | Listing pages are not long‑form articles; place-specific in-article units may misplace ads. |
| In‑feed / Matched content | ON if eligible | ON (controlled density) | Matches list structure; enforce frequency limits. |
| Anchor (sticky) | OFF | OFF for listing pages with contact/quote CTAs | Sticky can obscure CTAs and cause accidental clicks. |
| Vignette / Interstitial | OFF | OFF | Disruptive to selection and request flow. |
| Auto Ads URL exclusions | — | Exclude /contact /quote /booking /checkout /thank-you and detail pages with inline booking or quote forms | Prevent Auto Ads in conversion flows. |

Action:
- Use page-level attribute (e.g., `data-ads-layout="event-listing"`) and server-side flags to prevent Auto Ads from injecting in guarded zones.
- Keep Anchor & Vignette disabled for pages that funnel to contact/quote actions.

---

## 3) Conversion‑safe suppression zones — exact rules

Implement server-side suppression preferred; client-side distance checks as fallback.

A. Template / server flags
- `listing_sensitive = true` when cards include immediate `.price`/`.quote-cta` or inline contact widgets. Ad renderers must check it.

B. Spatial & adjacency rules (enforceable)
- Do NOT render any ad-slot whose top edge is within **300px vertical** of `.quote-cta`, `.contact-cta`, `.price`, or interactive selectors.
- `contact-guard` is a reserved non-ad block around contact/quote CTA where **no ad may render**.
- Maintain at least **2-card** separation between an in‑feed ad and nearest card with active contact/quote CTA.
- Do not place `top-banner` if it pushes first result with CTA below fold.

C. Session & referral suppression
- If user arrives via paid campaign (`utm_medium=cpc` and `utm_campaign` indicates high intent), suppress in‑feed ads for that session (30–60 minutes) to keep focus on contact/quote actions.
- If user clicks a quote/contact CTA, continue suppression for the session.

D. Filter/control area safety
- Do NOT place ads adjacent to filter panels, calendar selectors, or sort controls.

E. Pagination & repeated exposure
- Avoid repeating identical creatives across paginated pages in one session.

Developer checklist
1. Add `listing_sensitive` to server template context and expose in page HTML.  
2. Compute ad insertion points server-side to ensure card separation and distance rules.  
3. Use IntersectionObserver to lazy-load ad slots at ~400px threshold.  
4. Persist session suppression state for paid visitors (sessionStorage or first-party cookie).

---

## 4) Policy checklist — compliance & must-avoid items

Placement & UX
- Ads must not mimic contact buttons, price badges, or navigation.  
- No ads inside card DOMs or within the same parent as `.quote-cta` or `.contact-cta`.  
- Anchor/sticky ads disabled on listing pages with immediate contact/quote CTAs.

Affiliate & widget compliance
- If listings link to third‑party planners or aggregator widgets:
  - Disclose partner/affiliate relationship near CTA: e.g., “Partner service. Commission may apply.”  
  - Do not allow third‑party iframe to render ads inside the iframe; ads must be on parent page outside widget.  
  - Ensure listing data (prices, availability) is accurate.

Content moderation & rights
- Use licensed or owned images only. Moderate UGC (reviews) for profanity, PII, and copyright.  
- Label paid or incentivized listings/reviews.

Privacy & consent
- Respect GDPR/CCPA; do not serve personalized ads before consent where required.  
- Make privacy policy and consent options accessible.

Invalid traffic & click safety
- Monitor for CTR anomalies: high CTR but low contact/quote rates may indicate accidental clicks. Pause placements and investigate.  
- Implement alerting thresholds for booking/contact pages.

Logging & auditing
- Log ad slots served per session with `listing_sensitive` and session source for analysis.

---

## 5) 7‑Day Test Plan with KPI targets

Objective: monetize event planning listing pages while protecting contact/quote conversions.

Test design: A/B split (50/50)
- Control (A): current listing page (Auto Ads only or minimal manual units).  
- Test (B): manual in‑feed placements: `listing-infeed-1`, optional `listing-infeed-2`, `sidebar-1` (desktop). Auto In‑feed ON. Enforce suppression rules and session suppression for paid referrals.

Duration & sample size
- 7 days or until **≥5,000 listing pageviews per variant** (adjust to traffic).

Metrics to capture daily
- Listing pageviews  
- Card Quote/Contact CTA Click-Through Rate (CTA CTR)  
- Contact/Quote request conversion rate (CVR) from listing sessions  
- Page RPM (AdSense)  
- Ad CTR (per-slot)  
- CLS & LCP  
- Bounce rate and session duration

KPI table — baseline vs test targets & action thresholds

| KPI | Baseline | Test target | Immediate action threshold |
|---|---:|---:|---|
| CTA CTR (quote/contact) | baseline | No decrease >4% relative | If drop >4% pause Test B |
| Contact/Quote CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental clicks | If CTR spikes & conversions low pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholder CSS and defer ad load |
| LCP (mobile) | baseline | ≤+15% increase | If >+15% optimize images/defer ads |
| Bounce rate | baseline | Not increase >7% | If increase >7% investigate ad interference |

Day-by-day execution
- **Day 0**: Implement ad placeholders with reserved heights; add `listing_sensitive` flag; implement server-side insertion with separation; configure GTM A/B split and GA4 events: `event_listing_view`, `card_quote_click`, `contact_started`, `contact_confirmed`.
- **Day 1 (launch)**: Start 50/50 split. Monitor hourly for first 6–8 hours for JS errors, ad disapprovals, and CTR anomalies.
- **Days 2–3**: Daily reviews. If CTA CTR or CVR declines >3% trend, reduce density (remove `listing-infeed-2` or `sidebar-1`).
- **Day 4**: Mid-test adjustments.  
- **Days 5–6**: Stabilize placements or further reduce density.  
- **Day 7**: Analyze results. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and iterate.

Reporting deliverable
- Test report: RPM delta, CTA CTR delta, CVR delta, per-slot CTR, CLS/LCP deltas, recommended steady-state configuration.

---

## Developer handoff snippets

CSS placeholders
```css
.ad-listing-infeed { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
[data-listing-sensitive="true"] .ad-top-banner { display:none !important; }
.contact-guard { min-height:100px; /* reserved no-ad zone near CTAs */ }
```

Server-side insertion pseudo
```py
# insert ad after card index 3 and 10 if separation rules allow
positions=[]
for i, card in enumerate(cards):
  if i>2 and i%6==3 and not card.has_contact_cta:
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
- `event_listing_view`  
- `card_quote_click`  
- `contact_started`  
- `contact_confirmed`

Logging
- Add per-request fields: `page_type`, `category`, `listing_sensitive`, `session_source`, `slot_name`, `creative_id`.

---

If you want I can:
- Provide ready-to-paste HTML/CSS for `listing-infeed-1`, `sidebar-1`, and `post-listing-1` with ARIA labels.  
- Generate GTM container JSON for the A/B split and GA4 event tags for import.  
- Create a GA4 dashboard spec (charts and filters) to monitor KPIs during the 7‑day test.

Which artifact should I prepare next?
