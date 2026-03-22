# AdSense Implementation Plan — Hotel Package Stay (Detail Page)  
Site: https://balitatittour.com  
Page: Hotel package detail (single package / room type — price, availability, booking CTA, policies)

Implementation‑ready guidance developers and monetization owners can apply immediately. Priority: protect price clarity and bookings, avoid accidental ad clicks, keep fast UX.

---

## 1) Placements — block names, sizes, position & rules

| Block name | Position | Recommended sizes | Density / Visibility rule |
|---|---:|---:|---|
| hero-banner | Under hero photo, above summary (desktop) | 728×90 or responsive | Desktop only. Show only if primary CTA remains above fold. |
| inline-1 | In-content after short summary / first H2 | 300×250 responsive / 336×280 | Primary in-article unit. Lazy‑load. Place below summary not adjacent to price or CTA. |
| price-ad-guard | (reserved area) adjacent to price — NOT an ad | N/A | Reserve space to prevent ads near price; no ads allowed in this block. |
| sidebar-1 | Right rail beside availability/pricing (desktop) | 300×250 or 300×600 | Desktop only; hide on mobile. |
| inline-2 | Mid-content (after itinerary or room details) | 300×250 responsive | Optional for long pages (>900 words). One only. |
| post-content-1 | Below description, amenities, policies and reviews | 300×250 responsive | Lazy‑load at end of content; safe place for monetization. |
| mobile-inline | Mobile in-content (after summary) | 320×100 responsive | Only one mobile inline allowed above fold and only if it does not push CTA below fold. |
| sticky-anchor | Mobile sticky footer | 320×50 | Use cautiously: OFF on booking-heavy detail pages. |
| confirmation-slot | Confirmation page only (NOT on detail page) | responsive small display | Do not place on detail if booking remains on site. |

Notes:
- Do not place ads inside price or availability containers.
- Above-the-fold ads cap: Desktop ≤2 visible ads; Mobile ≤1 visible ad.
- Reserve CSS heights to prevent CLS (see test plan).

---

## 2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Hotel detail page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON (allowed) | Complements manual units on editorial sections. |
| In‑article | ON | ON for long package descriptions; OFF for short transactional pages | Useful for long descriptions; avoid when booking CTA dominates. |
| In‑feed / Matched content | ON if eligible | OFF | Not applicable to a single detail page. |
| Anchor (sticky) | OFF | OFF for booking-heavy hotel details; conditional ON for informational pages | Sticky may obscure booking controls; test cautiously off by default. |
| Vignette / Interstitial | OFF | FORCE OFF | Disruptive to booking flow and UX. |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /payment /seat-select /thank-you and detail pages used as inline booking steps | Keeps transactional flow ad-free. |

Action:
- Use a page-level flag (e.g., `data-ads-type="hotel-detail"` and `data-booking-sensitive="true/false"`) so Auto Ads and site code can make per-page decisions.
- Keep Anchor and Vignette OFF for pages with immediate booking interaction.

---

## 3) Conversion‑safe suppression zones — exact rules

A. Template / server flag
- `booking_sensitive = true` for hotel detail pages with visible booking widget, calendar picker, price badge, or immediate Book CTA. Ad renderers must check this flag.

B. Spatial suppression (enforceable)
- **No ads within 350px vertical distance** of `.price`, `.availability`, `#booking-form`, or `.book-cta`.
- `price-ad-guard` is a reserved block adjacent to price where **no ad may render**.
- Do not render `hero-banner` if it pushes price/CTA below the fold.

C. Session & referral suppression
- If user arrives via paid campaign (`utm_medium=cpc` and `utm_campaign` contains BOOK/BOOKING), suppress in-article and in-feed ads for that session or until booking completes (30–60 minutes).
- If user clicks Book CTA, suppress further ad loads in that session.

D. Checkout/payment pages
- **Strict**: block all ad requests on `/booking`, `/checkout`, `/payment`, `/seat-select`, `/thank-you`. Enforce server-side.

E. Mobile specifics
- On mobile hide `sidebar-1`. Only allow `mobile-inline` or `post-content-1` when they meet distance rules.

Developer enforcement checklist (priority)
1. Add `booking_sensitive` flag to server-rendered template context.  
2. Server-side placement decisions preferred; fallback to client-side distance checks before requesting ad tags.  
3. Use IntersectionObserver to lazy load ad slots only when ≥400px from potential CTA region.

---

## 4) Policy checklist — must-follow items

Placement & UX
- NEVER place ads inside or overlapping price, availability, calendar pickers, or booking CTA.
- NO ads that mimic booking controls or price badges.
- NO anchor or interstitial ads that obscure booking elements.

Affiliate & widget compliance
- If embedding third-party booking widgets or affiliate flows:
  - Add clear disclosure near booking CTA (e.g., “Partner booking. Commissions may apply”).
  - Do NOT let booking iframes render ads inside them; ads must be on parent page outside widget.
  - Ensure price and availability data are accurate and clearly presented.

Content & moderation
- Use only licensed/owned images. Avoid sensational imagery that misrepresents safety.
- Moderate reviews; remove PII and unauthorized copyrighted content.

Privacy & consent
- Follow GDPR/CCPA: do not serve personalized ads before consent where required.
- Ensure Privacy Policy accessible on detail pages.

Invalid traffic & click safety
- Monitor for CTR anomalies on booking-sensitive pages. If CTR spikes with no conversions, pause and investigate possible accidental clicks or fraud.

Logging & auditing
- Log which ad slots were served per page and include page flags to analyze correlation with conversion changes.

---

## 5) 7‑Day Test Plan with KPI targets

Goal: monetize hotel detail pages while protecting booking conversions and UX.

Test design: Randomized A/B split 50/50
- Control (A): existing page (minimal/no ads on detail page).
- Test (B): implement `inline-1`, `post-content-1`, `sidebar-1` (desktop) with suppression rules active. Auto in-article enabled only for long descriptions; anchor OFF.

Sample size & duration
- 7 days or until **≥4,000 detail pageviews per variant**.

Metrics to capture daily
- Detail pageviews
- Book CTA Click-Through Rate (Book CTR)
- Booking conversion rate (CVR) from detail page sessions
- Page RPM (AdSense)
- Ad CTR (per-slot)
- CLS and LCP
- Time on page and scroll depth

KPI table: baseline vs test targets & action thresholds

| KPI | Baseline | Test target | Action threshold |
|---|---:|---:|---|
| Book CTR | baseline | No decrease >4% relative | If drop >4% pause Test B immediately |
| Booking CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift target | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental click spikes | If CTR spikes and conversions low pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholder CSS and defer ad loads |
| LCP (mobile) | baseline | ≤+15% overhead | If >+15% optimize assets or defer ad loads |
| Time on page | baseline | Not reduced >7% | If reduced >7% review placements |

Day-by-day execution
- **Day 0**: Instrument templates (ad placeholders, `booking_sensitive` flag), server-side ad insertion logic, and GTM A/B split. Ensure GA4 events: `detail_view`, `book_cta_click`, `booking_started`, `booking_confirmed`.
- **Day 1 (launch)**: Start 50/50 split. Monitor hourly first 6–8 hours for JS errors, ad disapprovals, and CTR anomalies.
- **Days 2–3**: Check daily trends. If Book CTR or CVR shows >3% negative trend, reduce density (remove `sidebar-1` or defer `inline-1` further down).
- **Day 4**: Mid-test adjustment if needed.
- **Day 6**: Final troubleshooting & prepare report.
- **Day 7**: Detailed analysis. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and test lower density or changed positions.

Reporting deliverable
- One-page summary: RPM delta, Book CTR delta, CVR delta, CLS/LCP deltas, per-slot performance, recommendation (Keep / Reduce / Re-test).

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
  if (location.search.includes('utm_medium=cpc') && location.search.includes('BOOK')) {
    sessionStorage.setItem('ads_suppressed','1');
  }
  if (sessionStorage.getItem('ads_suppressed') === '1') {
    document.querySelectorAll('.in-article-ad').forEach(a=>a.style.display='none');
  }
}
```

GTM events to create
- `hotel_detail_view`
- `book_cta_click`
- `booking_started`
- `booking_confirmed`

---

If you want I can:
- Produce ready-to-paste HTML/CSS ad slot snippets for each block with aria labels and responsive rules.
- Generate GTM container JSON for A/B split and GA4 event tags for immediate import.
- Create a GA4 dashboard spec to monitor the KPIs during the 7‑day test.

Which artifact would you like next?
