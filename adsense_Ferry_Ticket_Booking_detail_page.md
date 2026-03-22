# AdSense Implementation Plan — Ferry Ticket Booking (Detail Page)  
Site: https://balitatittour.com  
Page: Ferry ticket detail (single sailing — timetable, price, booking CTA)

Practical, implementation‑ready guidance for developers and publishers. Priorities: protect bookings, avoid accidental clicks, keep good UX, and capture safe RPM.

---

1) Placements — block names, sizes, position, rules

| Block name | Position | Recommended sizes | Visibility rule |
|---|---|---:|---|
| top-banner | Under header, above service summary (desktop only) | 728×90 or responsive | Desktop only. Show only if primary CTA remains above fold. |
| inline-1 | In-content after short highlights (below first 150–250px) | 300×250 responsive / 336×280 | Lazy‑load; ensure ≥400px vertical distance from booking form. |
| sidebar-1 | Right rail beside timetable and price (desktop only) | 300×250 or 300×600 | Desktop only; hide on mobile. |
| mobile-inline | Mobile in-feed slot (after summary) | 320×100 responsive | Load only after user scrolls past booking summary by 400px. |
| post-content-1 | Bottom of page after details, policies, reviews | 300×250 responsive | Lazy‑load when user reaches bottom. |
| confirmation-slot | Reserved for confirmation page only (not detail) | Responsive small display | DO NOT serve on detail page if booking continues. |
| sticky-anchor | (NOT recommended) mobile sticky footer | N/A | Disabled for detail pages (high accidental click risk). |

Practical notes:
- Above-the-fold cap: Desktop ≤2 ads visible; Mobile ≤1 ad visible.
- Reserve CSS space for slots (see Guardrails). Avoid inserting ads inside or adjacent to #booking-form or .booking-cta.

---

2) Auto Ads — ON / OFF recommendations

| Auto Ad format | Global default | Ferry detail page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON but subject to page suppression flag | Good inventory; controlled by page flags. |
| In-article | ON | OFF on this transactional page | Not suitable for short transactional content. |
| In-feed / Matched content | ON if eligible | OFF | Listing style only; avoid on single detail pages. |
| Anchor (sticky) | OFF (recommended) | FORCE OFF | Sticky ads can overlap or be mistaken for booking controls. |
| Vignette / Interstitial | OFF | FORCE OFF | Disruptive to purchase flow. |
| Auto Ads URL exclusions | — | Exclude /booking /checkout /seat-select /payment /thank-you | Prevent auto placements inside conversion flow. |

Action items:
- Keep Auto Display ON globally; add a page-level meta/data flag (e.g., data-ads-allow="false" or booking_sensitive) on detail templates to block unwanted Auto placements.
- Verify Auto Ads reports to ensure no anchor/interstitial appears on suppressed pages.

---

3) Conversion‑safe suppression zones — exact rules to implement

A. Template flag (server-side)
- Add booking_sensitive = true to ferry detail templates. All ad renderers must check this flag before injecting ads.

B. Spatial suppression rules (CSS/JS)
- Do not place or render any ad-slot whose top edge is within 300px vertical distance of #booking-form or .booking-cta.
- Do not render top-banner if header + CTA are pushed below fold.
- On mobile hide sidebar-1 entirely.

C. Session & referral suppression
- If user arrives with utm_medium=cpc and utm_campaign contains BOOK (high intent), suppress inline ads for that session until booking completes or after 30 minutes.
- If user clicks Book CTA but does not complete booking, maintain ad suppression for remainder of session.

D. Checkout and payment pages
- Enforce no-ads at template level on /booking /checkout /payment /seat-select and any third‑party payment redirects.

E. Pagination and repeated exposure
- Do not show the same ad repeatedly across paginated detail variations within same session; rotate or suppress.

Developer implementation checklist (short)
1. Add booking_sensitive flag to template.  
2. Use server-side suppression for speed; fallback to JS distance checks.  
3. Lazy-load with IntersectionObserver (threshold ~400px).  
4. Store session suppression on first-party cookie for paid/referral visitors.

---

4) Policy checklist — must follow for detail pages

Placement & UX
- No ads inside, on top of, or overlapping booking form, seat selector, price, or payment button.
- No ads that mimic booking controls, price badges, or nav elements.
- No anchor (sticky) or vignette ads on booking-flow pages.

Affiliate & widget compliance
- If embedding third‑party booking widgets (iframe):
  - Parent page must contain primary content and clear affiliate disclosure if applicable.
  - Do not allow iframe to display ads. Place ads only on parent page outside widget area.
  - Disclose affiliate relationship near the booking CTA (e.g., “Partner booking. Commissions may apply”).

Content moderation & image rights
- Use licensed images only. Do not show graphic or misleading imagery.
- If showing reviews: moderate content, disclose sources, do not show personal contact info.

Privacy & consent
- Do not serve personalized ads before obtaining consent where required (GDPR/CCPA).
- Ensure privacy policy accessible on booking/detail pages.

Invalid traffic & click safety
- Monitor for sudden CTR spikes on booking-sensitive pages; investigate & pause placements if suspicious.
- Add unreachable ad test (small %) to detect bots/click fraud if necessary.

---

5) 7‑Day Test Plan with KPI targets

Purpose: validate in-page monetization while protecting booking conversions.

Test design: A/B 50/50 split
- A (Control): current page with minimal/no ads on detail page.
- B (Test): slots enabled per plan — inline-1, sidebar-1 (desktop), post-content-1; suppression rules active. Auto Display allowed but in-article and anchor forced OFF.

Duration & minimum volume
- 7 days or until ≥5,000 detail page views per arm.

Metrics to track (daily)
- Detail pageviews
- Book CTA Click-Through Rate (Book CTR)
- Booking conversion rate (CVR) from detail page sessions
- Page RPM (AdSense)
- Ad CTR (per-slot)
- CLS and LCP
- Bounce rate

KPI targets & action thresholds

| KPI | Baseline | Test target | Immediate action threshold |
|---|---:|---:|---|
| Book CTR | baseline | No decrease >4% relative | If drop >4% pause Test B immediately |
| Booking CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | ≥ +20% uplift desirable | If RPM < +10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for spikes indicating accidental clicks | If CTR spikes and conversions low pause placements |
| CLS | baseline | ≤0.10 | If CLS >0.10 reduce placeholder changes and defer ad load |
| LCP (mobile) | baseline | ≤+15% increase | If >+15% optimize assets or defer ad loading |

Day-by-day execution
- Day 0: Implement ad placeholders with reserved CSS heights; add booking_sensitive flag; add session suppression and GTM A/B split; ensure GA4 events for book_cta_click and booking_confirm are in place.
- Day 1 (launch): Start 50/50. Monitor hourly first 6–8 hours for disapprovals, JS exceptions, or odd CTR spikes.
- Days 2–4: Daily review. If Book CTR or CVR declines >3% trend, reduce density (remove sidebar-1 or inline-1).
- Day 5: Mid-test adjustments (density reduction or slot move) if needed.
- Day 7: Evaluate. Accept Test B only if CVR drop ≤5% and RPM uplift ≥20%. Otherwise revert and iterate.

Reporting outputs (post-test)
- Table with baseline vs test: RPM, Book CTR, CVR, CLS, LCP.
- Recommendation: keep slots (which) or revert and propose next smaller-density test.

---

Quick technical snippets (developer-ready)

CSS reserved space (example)
```css
.ad-inline-1 { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
[data-booking-sensitive="true"] .ad-top-banner { display:none !important; }
```

JS suppression pseudocode
```js
if (page.booking_sensitive) {
  const cta = document.querySelector('#booking-form');
  document.querySelectorAll('.ad-slot').forEach(slot => {
    const distance = slot.getBoundingClientRect().top - cta.getBoundingClientRect().bottom;
    if (distance < 300) slot.style.display = 'none';
  });
  // session suppression for paid visitors
  if (utm_medium === 'cpc' && utm_campaign.includes('BOOK')) {
    sessionStorage.setItem('ads_suppressed', '1');
  }
}
```

GTM events to create
- detail_page_view (on page load)
- book_cta_click (on click)
- booking_started (on booking form submit)
- booking_confirmed (on thank-you page)

---

Would you like:
- Ready-to-paste HTML/CSS placeholders and the exact GTM tag/trigger JSON for A/B split and events, or
- A short monitoring dashboard spec for GA4 to visualize the KPIs above?

Which next step do you prefer?
