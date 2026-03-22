# AdSense Implementation Plan — Category: Ferry Ticket Booking (Listing Page)  
Site: https://balitatittour.com  
Page type: Ferry ticket listing page (search results / timetable list / multiple sailings)

This is an implementation‑ready plan focusing on monetization while protecting booking conversions. Use the block names and rules below as drop‑in templates for developers and publishers.

---

1) Placements (block names with sizes, position & rules)

| Block name | Position (desktop / mobile) | Recommended sizes | Allowed Density | Load rule |
|---|---:|---:|---:|---|
| listing-slot-1 | In-feed: between result items 4 and 5 (desktop & mobile) | Responsive 300x250 | 1 per 8 items | Lazy-load when within 400px of viewport |
| listing-slot-2 | In-feed: mid-list (after item 12) | Responsive 300x250 | 1 per 12 items | Lazy-load |
| top-banner | Above results, under header (desktop only) | 728x90 / responsive | 1 (desktop) | Show only if results header still visible above fold |
| sidebar-1 | Right rail beside list (desktop only) | 300x250 / 300x600 | 1 | Desktop only; hide on mobile |
| mobile-inline | In-feed mobile small (between items 3 and 4) | 320x100 responsive | 1 per 8 items | Lazy-load; ensure not within 300px of CTA controls |
| post-content-1 | Below listings / pagination | Responsive 300x250 | 1 | Lazy-load after user scrolls end |

Notes:
- Keep visible ad units per viewport conservative: Desktop max 2 ads above-the-fold; Mobile max 1 above-the-fold.
- Do not place ads inside listing item controls (book now buttons, date selectors).

---

2) Auto Ads: ON / OFF settings (global vs per-page)

| Auto Ad format | Global default | Listing page override | Rationale |
|---|---:|---:|---|
| Display (responsive) | ON | ON | Good for feed/listing pages; will supplement manual in-feed units |
| In-article | ON | OFF | Listing pages are structured lists not long-form articles; avoid misplaced in-article units |
| In-feed / Matched content | ON if eligible | ON | Matches listing feed format; use 1 unit per 8 items max |
| Anchor (sticky) | OFF (recommended) | FORCE OFF | Avoid accidental clicks near book buttons when users scroll listings |
| Vignette / Interstitial | OFF | FORCE OFF | Interstitials disrupt selection flow and can reduce conversions |
| Auto Ads URL exclusions | — | Add listing page query params if listing is part of booking flow to exclude from auto placements near CTA | Prevent auto ad injection in areas that contain booking widgets

Implementation:
- Enable Auto Ads Display + In-feed globally, but set page-level data attribute (e.g., data-ads-layout="listing") so Auto Ads won't inject in guarded zones.
- Ensure Auto Ads Anchor and Vignette remain OFF.

---

3) Conversion‑safe suppression zones (exact rules to implement)

Purpose: avoid accidental clicks and protect CTR → conversion correlation.

A. Template flags and server-side rules
- listing_sensitive = true for pages that combine search/list results with inline booking controls.
- If listing_sensitive = true, disable:
  - top-banner (desktop) if it pushes first result below fold
  - any ad within 300px of item booking buttons or the page filter controls
  - anchor/sticky ads on the page

B. In-feed placement spatial rules
- Do not insert in-feed ad immediately adjacent to or within the same DOM container as any “Book” button or price control.
- Minimum separation: at least 2 listing items between an ad and any item with active seat selection or “Book Now” CTA.

C. Interaction & session-level suppression
- If user arrives with utm_medium=cpc and utm_campaign contains BOOK or similar high‑intent tag, suppress in-feed ads for the session until a booking is completed or for 30 minutes. Rationale: preserve conversion intent for paid visitors.
- If user clicks any listing “Book” button, suppress further ad loads in that session on the listing/detail/checkout chain.

D. Pagination behavior
- Avoid showing the same ad repeatedly across paginated pages within the first two pages to prevent fatigue and accidental clicks.

Implementation snippet idea (pseudo logic)
- On page render:
  - Identify all listing items and their CTA positions.
  - Compute ad slot positions so that smallest distance from any CTA ≥ 300px.
  - Add data attribute to ad slots to prevent Auto Ads injection in those coordinates.

---

4) Policy checklist — must follow for listing pages

Ad content and placement safety
- Do not display ads that mimic booking buttons or look like site navigation.
- Ads must not overlay listing controls, prices, or selection widgets.
- No sticky/anchor ads that could cover native “Book” buttons.

Affiliate and widget compliance
- If listing includes third‑party booking widgets or affiliate links:
  - Disclose affiliate relationship near CTA (e.g., “Partner booking. Commissions may apply”).
  - Ensure affiliate widget does not inject ads inside its iframe.
  - Parent page must have primary content and proper privacy disclosures.

Content moderation and accuracy
- Prices displayed must be correct and updated; do not place ads directly next to price info that could be mistaken for price content.
- UGC (reviews) used in listings must be moderated and not display personal data or copyrighted excerpts without permission.

Privacy and consent
- Ads that use personalized signals must only deliver after required consent in applicable regions.
- Ensure CCPA/GDPR consent banners are visible and block ad personalization until consent granted.

Invalid traffic and click safety
- Monitor for spikes in CTR on listing pages; high CTR + low conversions may indicate accidental clicks. Implement immediate pause rules and investigate.

---

5) 7‑Day Test Plan with KPI targets

Goal: Validate in-feed monetization on listing pages without harming bookings.

Test variants: A/B test (50/50 split)
- Variant A (Control): Current listing page with NO manual in-feed ads, Auto Ads in-feed OFF.
- Variant B (Test): Listing page with listing-slot-1 (in-feed after item 4), listing-slot-2 (mid-list), top-banner desktop allowed, Auto Ads in-feed ON, suppression zones active.

Test duration: 7 days (or reach minimum of 5,000 listing page views per variant whichever earlier)

Metrics to capture pre-test baseline (7 days prior)
- Listing page views
- Booking click-through rate from listing (Book CTR)
- Booking conversion rate from listing visits (CVR)
- Page RPM (AdSense)
- Ad CTR
- CLS & LCP for listing pages

KPI targets (acceptance criteria)

| KPI | Baseline | Test target (acceptable change) | Action threshold |
|---|---:|---:|---|
| Book CTR (clicks on Book buttons) | baseline | No decrease >4% relative | If drop >4% revert immediately |
| Booking conversion rate (from listing visits) | baseline | No decrease >5% relative | If drop >5% pause Test B |
| Page RPM | baseline (e.g., $0.80) | ≥ +20% uplift (target $0.96+) | If RPM increase <10% and conversion drop >2% revert |
| Ad CTR | baseline | Monitor for spikes; acceptable up to +50% | If Ad CTR spikes with low conversions suspect accidental clicks and pause |
| CLS | baseline (e.g., 0.04) | ≤0.10 acceptable | If CLS >0.10 reduce ad placeholders or reserve more space |
| LCP (mobile) | baseline | No more than +15% | If >+15% optimize assets/defer ads |

Day-by-day plan
- Day 0: Prepare A/B split, deploy ad placeholders for variant B, enable Auto in-feed for B only, set suppression rules. Ensure GA4/Ads tracking for Book CTR and conversions.
- Day 1: Launch test. Monitor hourly for first 6–8 hours for disapprovals, huge CTR spikes, or JavaScript errors.
- Day 2–3: Monitor daily metrics. Add immediate negatives for any ad network search terms causing irrelevant traffic (if applicable).
- Day 4: Mid-test review. If Book CTR or CVR shows downward trend >3%, move to reduce density (remove top-banner or listing-slot-2).
- Day 6: Final adjustments based on trends (reduce density if CVR trending down or maintain if stable and RPM improving).
- Day 7: Analyze results. Accept Test B if RPM uplift ≥20% and CVR change within −5% to +∞. Otherwise revert and iterate with lower density.

Reporting deliverable after 7 days
- Summary: RPM change, Book CTR change, CVR change, CLS/LCP deltas.
- Recommendation: Keep which slots, remove which, or re-run with modified positions.

---

Developer Handoff Checklist (quick actionable items)
1. Create ad slot placeholders with classes: .ad-listing-slot-1 .ad-listing-slot-2 .ad-top-banner .ad-sidebar-1 .ad-mobile-inline .ad-post-content-1 and include reserved min-height CSS.
2. Add page flag listing_sensitive = true to template to enforce suppression logic.
3. Implement JS to compute distances between ad slots and CTA elements and hide any violating slots (distance < 300px).
4. Implement lazy-load via IntersectionObserver with threshold 400px for in-feed slots.
5. Configure Auto Ads with in-feed ON globally but exclude booking/checkout URLs and make page-level override to prevent injection inside suppression zones.
6. Implement A/B split and GTM events to capture Book CTR and conversions mapped to variant.
7. Start 7‑day test, monitor, and produce report.

---

If you want I can:
- Provide ready-to-paste HTML/CSS snippets for the ad placeholders with min-height and aria labels.
- Produce GTM preview configuration for the A/B split and event tracking for Book CTR.
- Create a reporting dashboard spec (GA4) with all KPIs wired.

Which of those should I generate next?
