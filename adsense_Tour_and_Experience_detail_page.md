# AdSense Implementation Plan — Tour & Experience (Detail Page)  
Site: https://balitatittour.com  
Page: Tour / Experience detail (single tour page — itinerary, inclusions, price, Book CTA)

Practical, implementation‑ready instructions developers and monetization owners can apply immediately. Priority: protect booking conversions and UX while capturing safe RPM from editorial/detail content.

---

## 1) Placements — block names, sizes, position & rules

| Block name | Position | Sizes (recommended) | Density / Visibility rule |
|---|---:|---:|---|
| hero-banner | Under hero image, above itinerary summary (desktop only) | 728×90 or responsive | Desktop only. Show only if Book CTA remains above fold. |
| inline-1 | In‑content after intro / first H2 | 300×250 responsive / 336×280 | Primary in-article unit. Lazy‑load. Ensure ≥400px vertical distance from booking CTA. |
| inline-2 | Mid-article (after H2/H3) for long pages (>800 words) | 300×250 responsive | Optional. One only per long page. |
| sidebar-1 | Right rail beside itinerary/prices (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile. |
| post-content-1 | Bottom of page after itinerary, FAQs, reviews | 300×250 responsive | Lazy‑load at page end; low interference. |
| mobile-inline | Mobile in-article slot (after summary) | 320×100 responsive | Only one mobile in-article allowed above fold and only if it does not push CTA below fold. |
| sticky-anchor | Mobile sticky footer ad | 320×50 | Use cautiously. OFF for booking-heavy pages. |
| confirmation-slot | (NOT on detail page) reserved for confirmation page only | responsive small display | DO NOT use on detail pages that lead to onsite checkout flow. |

Implementation notes:
- Above-the-fold ads cap: Desktop ≤2 visible ads; Mobile ≤1 visible ad.
- Reserve CSS height for all slots to prevent CLS (see Guardrails in test plan).

---

## 2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Detail page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON (allowed) | Supplements manual units; controlled by page-level flags. |
| In‑article | ON | ON for long-form tour pages; OFF for short transactional detail pages | Good for long itineraries; avoid when immediate booking CTA dominates. |
| In‑feed / Matched content | ON if eligible | OFF | Not applicable for single detail pages. |
| Anchor (sticky) | OFF | Conditional: allowed only on informational tour pages, OFF on booking-heavy pages | Sticky increases RPM but can obscure CTA; use with A/B test. |
| Vignette / Interstitial | OFF | FORCE OFF | Disruptive to reading and booking. |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /payment /seat-select /thank-you | Keep checkout/booking ad-free. |

Action items:
- Use a page-level attribute (e.g., data-ads-type="tour-detail" and data-booking-sensitive="true/false") so Auto Ads respects page context.
- Keep Anchor and Vignette OFF for booking_sensitive pages.

---

## 3) Conversion‑safe suppression zones — exact rules to implement

A. Template / server flag
- Add `booking_sensitive = true` to tour/detail page context when page contains immediate booking widget, price CTA, seat selection or payment controls. Ad rendering logic must check this flag.

B. Spatial suppression (enforceable)
- Do NOT render any ad-slot whose top edge is within **300px vertical** distance of `#booking-form` or `.book-cta`.
- Do NOT place `inline-1` directly above the Book CTA; ensure a minimum of **400px** between inline-1 and booking CTA.
- Hide `sidebar-1` on mobile always.

C. Session & referral suppression
- If user arrives with `utm_medium=cpc` and `utm_campaign` contains `BOOK` or similar high intent, set session suppression: **suppress in-article units** for that session or until booking completes (30–60 minutes default).
- If user clicks any Book CTA in session but does not complete, maintain suppression for the rest of that session.

D. Checkout/payment pages
- **Strict**: block all ad requests on `/booking`, `/checkout`, `/payment`, `/seat-select`, and `/thank-you` pages (server-side block).

E. Lazy-load rule
- Only request ads when slot is within **400px** of viewport (IntersectionObserver). Above-the-fold slots may load immediately but must be distance-safe relative to CTA.

Developer enforcement checklist (priority)
1. Implement `booking_sensitive` at template level.  
2. Server-side placement decision before returning HTML (preferred).  
3. Client-side distance check fallback: remove ad slots with distance < 300px to CTA.  
4. Use session cookie to record referral paid visits and suppress ads accordingly.

---

## 4) Policy checklist — what to avoid and required disclosures

Placement & UX
- NO ads inside, on top of, or overlapping the booking form, price, seat selector, or payment buttons.
- NO ads that mimic booking CTAs, price badges, or site navigation.
- NO anchor (sticky) or vignette ads that obscure CTA on booking-sensitive pages.

Affiliate & widget compliance
- If embedding third‑party booking widgets or affiliate flows:
  - Parent page must hold the primary content, not merely an ad shell.
  - Disclose affiliate relationship near the CTA: e.g., “Partner booking. Commissions may apply.”
  - Do NOT place ads inside iframe widgets. Ads must be outside widget boundaries.

Content moderation & rights
- Use licensed or owned images for content and ad creatives.  
- Moderate UGC (reviews) to avoid profanity, personal data leaks, or copyrighted content. Label paid reviews/partners.

Privacy & consent
- Respect regional consent rules (GDPR/CCPA): do not serve personalized ads before required consent.  
- Ensure Privacy Policy link visible and accessible.

Invalid traffic and click safety
- Monitor for CTR spikes on booking-sensitive pages; treat spikes as potential accidental clicks or invalid activity. Pause placements and investigate.

Reporting & logs
- Log which slots render for each session and include page flags in reporting to correlate with conversion trends.

---

## 5) 7‑Day Test Plan with KPI targets

Goal: add safe monetization to tour detail pages and measure impact on bookings.

Test design: A/B split — 50% Control (A) / 50% Test (B)

- Control (A): current page (minimal or no ads on detail page).
- Test (B): slots enabled per plan — `inline-1`, `post-content-1`, `sidebar-1` (desktop). `hero-banner` optional on non-booking-sensitive pages. Auto in-article ON for long pages; Anchor OFF.

Sample size & duration
- Run 7 days or until **≥4,000 detail pageviews per variant**.

Metrics to capture (daily)
- Detail pageviews
- Book CTA Click-Through Rate (Book CTR)
- Booking conversion rate (CVR) from detail page sessions
- Page RPM (AdSense)
- Ad CTR (per-slot)
- CLS and LCP
- Time on page / scroll depth
- Bounce rate

KPI table: baseline vs targets & action thresholds

| KPI | Baseline (capture prior) | Test target (acceptable) | Immediate action threshold |
|---|---:|---:|---|
| Book CTR | baseline | No decrease >4% relative | If drop >4% pause Test B immediately |
| Booking CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for abnormal spikes | If Ad CTR spikes with low conversions pause slots and audit |
| CLS | baseline | ≤0.10 acceptable | If >0.10 stop, reserve more space and defer ads |
| LCP (mobile) | baseline | ≤+15% overhead | If >+15% optimize images and defer ad loads |
| Time on page | baseline | Not reduced >7% | If reduced >7% review placements |

Day-by-day plan
- **Day 0**: Implement ad placeholders with reserved CSS heights and `booking_sensitive` flags. Set server-side ad placement logic. Configure GTM for A/B split and GA4 events: `detail_view`, `book_cta_click`, `booking_started`, `booking_confirmed`.
- **Day 1 (launch)**: Start 50/50 split. Monitor hourly for first 6–8 hours for JS errors, ad disapprovals, or CTR anomalies.
- **Days 2–3**: Review daily data. If Book CTR or CVR shows a >3% negative trend, reduce density by removing `sidebar-1` or moving `inline-1` lower.
- **Day 4**: Mid-test review and adjust placements if needed (e.g., move inline-1 after more content).
- **Day 6**: Final adjustments; remove any slot showing accidental click patterns.
- **Day 7**: Full analysis. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and iterate with lower density or alternate positions.

Reporting deliverable
- 1‑page summary with: RPM delta, Book CTR delta, CVR delta, CLS/LCP deltas, per-slot performance, recommendation (Keep / Reduce / Re-test).

---

## Quick developer handoff snippets

CSS reserved space (paste)
```css
.ad-inline-1 { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
.ad-hero-banner { width:100%; min-height:90px; }
[data-booking-sensitive="true"] .ad-hero-banner { display:none !important; }
```

JS suppression pseudo (paste)
```js
if (page.booking_sensitive) {
  const cta = document.querySelector('#booking-form');
  document.querySelectorAll('.ad-slot').forEach(slot => {
    const slotTop = slot.getBoundingClientRect().top + window.scrollY;
    const ctaBottom = cta.getBoundingClientRect().bottom + window.scrollY;
    if (slotTop - ctaBottom < 300) slot.style.display = 'none';
  });
  // session suppression for paid visitors
  if (location.search.includes('utm_medium=cpc') && location.search.includes('BOOK')) {
    sessionStorage.setItem('ads_suppressed', '1');
  }
  if (sessionStorage.getItem('ads_suppressed') === '1') {
    document.querySelectorAll('.in-article-ad').forEach(a=>a.style.display='none');
  }
}
```

GTM events to implement
- `detail_page_view` (page load)
- `book_cta_click` (click)
- `booking_started` (form submit)
- `booking_confirmed` (thank-you page view)

---

If you want I can:
- Generate ready-to-paste HTML/CSS placeholders for each slot and the exact GTM trigger JSON for the A/B split and events.
- Produce a GA4 dashboard spec (charts and filters) to monitor the KPIs during the 7‑day test.

Which follow-up would you like next?
