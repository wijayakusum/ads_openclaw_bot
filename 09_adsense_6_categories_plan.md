# AdSense Plan — balitatittour.com  
Site: Bali travel planner (tours, packages, booking). Categories: 1) Ferry Ticket Booking 2) Tour and Experience 3) Hotel Package Stay 4) Transfer Service 5) Car Rental 6) Event Planning

This plan is practical and implementation‑ready. Use it to configure AdSense placements, Auto Ads, UI guardrails and a 30‑day optimization roadmap. Where required, treat booking/checkout pages as conversion sensitive and reduce ad density.

---

A. Category Monetization Matrix

| Category | Ad intent level | Recommended ad density | Best ad formats | Expected RPM tier (USD) |
|---|---:|---:|---|---:|
| Ferry Ticket Booking | High (transactional) | Low | display (300x250), in-feed (listing), none on checkout | $2–6 |
| Tour and Experience | High–Medium | Medium | in-article, in-feed, display, responsive | $3–8 |
| Hotel Package Stay | High (booking) | Low–Medium | display, in-feed, in-article on content pages | $4–10 |
| Transfer Service | Medium (utility) | Low | display sidebar, in-feed, no anchor on booking | $2–5 |
| Car Rental | Medium–High | Medium | in-feed, display, in-article reviews | $3–7 |
| Event Planning | Low–Medium (B2B/seasonal) | Medium | in-article, display, in-feed on guides | $2–6 |

Notes:
- RPM tier is expected range per 1,000 pageviews after baseline optimization. Actual RPM depends on traffic source, geo, season, and ad quality.
- “Ad density” = conservative for booking flows, higher for editorial blog/guides.

---

B. Page‑Type Placement Rules by Category

Standard block names to use in templates:
- top-banner (leaderboard area under header)
- inline-1 (in-content after intro)
- inline-2 (in-content mid-article)
- post-content-1 (below article)
- sidebar-1 (desktop right rail)
- sticky-anchor (mobile footer sticky)
- interstitial (vignette / full screen)
- listing-slot (in listing feed)
- checkout-banner (above booking form)
- confirmation-slot (below confirmation message)

For each category, placements and restrictions:

1) Ferry Ticket Booking
- Listing page
  - listing-slot (in-feed ad between results) — density: 1 per 8 items
  - sidebar-1 (desktop) — allowed
- Detail page
  - top-banner — allowed (but small)
  - inline-1 — allowed
  - sidebar-1 — allowed
- Checkout/booking page
  - checkout-banner — DISABLED (no ads above or adjacent to form)
  - inline-1 — DISABLED
  - sticky-anchor — DISABLED
- Confirmation page
  - confirmation-slot — allowed (below confirmation message)
  - post-content-1 — allowed
Notes: suppress ads that could be mistaken for booking controls. No interstitials on checkout.

2) Tour and Experience
- Listing page
  - listing-slot — allowed
  - sidebar-1 — allowed
- Detail page
  - top-banner — allowed
  - inline-1 — allowed
  - inline-2 — allowed if article >800 words
- Checkout/booking page
  - checkout-banner — DISABLED (keep clean)
  - sticky-anchor — optional OFF
- Confirmation page
  - confirmation-slot — allowed (below fold)
Notes: in-article formats on long guides yield highest RPM; keep checkout ad-free.

3) Hotel Package Stay
- Listing page
  - listing-slot — allowed
  - sidebar-1 — allowed
- Detail page
  - top-banner — allowed
  - inline-1 — allowed
  - inline-2 — allowed for long content
- Checkout/booking page
  - checkout-banner — DISABLED
  - inline-1 — DISABLED
- Confirmation page
  - confirmation-slot — allowed
Notes: ensure price elements and availability controls are not adjacent to ads.

4) Transfer Service
- Listing page
  - listing-slot — allowed (low density)
- Detail page
  - inline-1 — allowed
  - sidebar-1 — allowed
- Checkout/booking page
  - checkout-banner — DISABLED
- Confirmation page
  - post-content-1 — allowed

5) Car Rental
- Listing page
  - listing-slot — allowed
- Detail page
  - top-banner — allowed small
  - inline-1 — allowed
- Checkout/booking page
  - checkout-banner — DISABLED
- Confirmation page
  - confirmation-slot — allowed

6) Event Planning
- Listing page
  - listing-slot — allowed
- Detail page
  - in-article units (inline-1) — allowed
  - sidebar-1 — allowed
- Checkout/booking page
  - checkout-banner — DISABLED
- Confirmation page
  - post-content-1 — allowed

General page rules:
- Booking/checkout pages: no top-banner that pushes CTA below fold, no inline ads inside form, no sticky-anchor on mobile.
- Confirmation pages: allow 1 ad block below confirmation message; do not place ads above or immediately next to confirmation code/CTA.

---

C. Auto Ads Configuration

Global Auto Ads settings (recommended ON/OFF)
- ON: Display (responsive), In-article, In-feed (if site has feeds), Matched content (if eligible)
- OFF: Anchor (sticky) globally by default, Interstitial (vignette) globally, Full-screen scroll ads
- Optimize: Enable Auto ad exclusions for booking/checkout/thank-you URL patterns.

Per-category overrides
- Ferry Ticket Booking: Auto Ads In-article ON on blog/listings only; disable Auto Ads on /booking /checkout /seat-select paths.
- Tour and Experience: Auto Ads In-article ON; allow in-feed on listing pages; disable anchor on booking pages.
- Hotel Package Stay: Auto Ads in-article ON; disable anchor and vignette on booking flows.
- Transfer & Car Rental: Auto Ads Display ON for listing/detail; disable anchor on booking pages.
- Event Planning: Auto Ads in-article ON for guides; disable Auto interstitials.

Policy‑safe limits and rationale
- Do not enable Anchor ads on conversion pages to avoid accidental clicks and policy complaints.
- Limit Auto in-article to 1 unit per article for mobile to keep content readable.
- Use Auto Ads URL exclusions for all checkout, payment, and confirmation endpoints.
- Review Auto Ads placements weekly; disable any placement with high accidental click rate or that reduces conversion rate.

---

D. Revenue vs Conversion Guardrails

Max ads per viewport
- Desktop: max 3 ads visible in initial viewport (above-the-fold + sidebar counted).
- Mobile: max 1–2 ads visible in initial viewport. Prefer content-first above-the-fold.

CLS-safe placeholders and lazy-load rules
- Reserve ad container dimensions in CSS before ad loads:
  - Use aspect-ratio or explicit min-height per breakpoint. Example CSS:
    - .ad-slot { width: 100%; min-height: 250px; } for 300x250 responsive
- Lazy-load ads below the fold with IntersectionObserver:
  - Only request ads when slot is within 300–500px of viewport.
  - Do not lazy-load above-the-fold ad units.

Suppress ads near CTA/buttons/forms
- Rules per category:
  - Ferry Ticket Booking, Hotel Package Stay, Car Rental, Transfer Service: no ad within 300px vertical distance of booking CTA or form controls. Implement with CSS selectors (e.g., .booking-form ~ .ad-slot { display: none; }).
  - Tour and Experience, Event Planning: allow inline ads but ensure first inline ad ≥250px below primary CTA and not inside sticky elements.
- Implement server-side or template-level suppression: add page-type flags to templates so AD code checks flags before rendering ad slots.

Ad frequency & user experience
- Do not show more than one interstitial per session and never on first visit to a checkout page.
- Allow users to close sticky/anchor ads with persistent “X” that hides for 24 hours.

---

E. AdSense Policy Checklist (Travel + Booking)

What to avoid per category
- Ferry Ticket Booking
  - Avoid misleading availability claims. Do not show ads that mimic seat selection UI.
  - Ensure booking widget disclosures and refund policy visible.
- Tour and Experience
  - Avoid images of dangerous activities without safety disclaimers.
  - UGC must be moderated for profanity and privacy.
- Hotel Package Stay
  - Avoid fake price comparisons or false scarcity. Must display accurate pricing and cancellation policy.
- Transfer Service
  - Avoid implying government endorsement or false credentials.
- Car Rental
  - Avoid deceptive insurance claims or omitted mandatory fees.
- Event Planning
  - Avoid impersonation of venues or misleading capacity claims.

Affiliate / booking widget compliance
- Disclose affiliate relationships (near price or CTA). Text like "Partner offer. Commissions may apply." is recommended.
- If embedding third-party booking widgets/iframes:
  - Ensure parent page has primary content and is not merely an ad shell.
  - Make widget sources trustworthy and ensure privacy/consent compatibility.
  - Ensure widget does not hide the site’s privacy policy or inject ads that violate policies.

Additional policy reminders
- No incentivized clicks, no encouraging clicks on ads.
- Do not place ads that mimic site navigation or booking controls.
- Moderate reviews and photos for copyright.
- Keep payment pages free from ads that might be confused with payment UI.

---

F. Implementation Blueprint for OpenClaw Agent

Reusable prompt template (replace CATEGORY and PAGE_TYPE)
- Prompt:
  ```
  OpenClaw task: Configure AdSense placements for CATEGORY on PAGE_TYPE.
  Template values:
  - Page flag: category=CATEGORY page=PAGE_TYPE
  - Required ad slots: [list available slots]
  - Booking sensitive: yes/no
  Implementation steps:
  1. Insert ad slot placeholders with CSS classes: ad-{slot} and reserved min-height.
  2. Add server-side flag to skip ad rendering when booking_sensitive = true.
  3. Add Auto Ads URL exclusion for URL patterns: /booking /checkout /thank-you
  4. Ensure GTM fires ad slots only after intersection threshold 300px.
  5. Add policy note: do not place ads within 300px of CTA.
  Output: Provide code snippets for HTML placeholder, CSS min-height, and GTM trigger config.
  ```
- Use this prompt to ask the agent to produce actual code snippets for each category/page combination.

Six ready-to-use prompt examples (one per category)
1. Ferry Ticket Booking Listing
   - Replace CATEGORY=Ferry Ticket Booking, PAGE_TYPE=Listing page, required slots = listing-slot sidebar-1.
2. Tour and Experience Detail
   - CATEGORY=Tour and Experience, PAGE_TYPE=Detail page, required slots = top-banner inline-1 inline-2 sidebar-1.
3. Hotel Package Stay Checkout
   - CATEGORY=Hotel Package Stay, PAGE_TYPE=Checkout page, required slots = none above form, confirmation-slot below fold.
4. Transfer Service Detail
   - CATEGORY=Transfer Service, PAGE_TYPE=Detail page, slots = inline-1 sidebar-1.
5. Car Rental Listing
   - CATEGORY=Car Rental, PAGE_TYPE=Listing page, slots = listing-slot sidebar-1.
6. Event Planning Blog Guide
   - CATEGORY=Event Planning, PAGE_TYPE=Blog post, slots = top-banner inline-1 post-content-1.

(Each example prompt should be fed to OpenClaw to produce HTML/CSS/GTM snippets.)

---

G. 30‑Day Optimization Plan (Week 1–4)

Overview:
- Goal: balance RPM with conversion rates on booking flows. Primary KPIs: RPM, CTR, session RPM, booking conversion rate (CVR).
- Baseline measurement: Week 0 capture RPM, CTR, CVR (pre-change).

Week 1 — Safe rollout & measurement
- Actions:
  - Implement ad placeholders and initial placements per category.
  - Enable Auto Ads with global OFF for Anchor and Interstitial. Exclude booking/checkout URLs.
  - Deploy lazy-load and CLS placeholders.
- Experiments:
  - A1: In-article inline-1 (after intro) vs inline-1 after first H2 on tour detail pages.
  - A2: listing-slot position top vs mid-list on ferry listings (1 per 5 vs 1 per 8).
- KPI targets to monitor daily: impressions, RPM, CTR, page load LCP, CLS.

Week 2 — Creative & placement tuning
- Actions:
  - Apply Variant B sitelinks/callouts across account.
  - Move high RPM categories (Hotel, Tours) to medium density on blog pages.
- Experiments:
  - B1: In-feed unit on hotel listing vs no in-feed.
  - B2: Sticky-anchor on blog mobile only (controlled 50% roll out) — but disabled on booking flows.
- Evaluate: conversion lift/drop and RPM delta.

Week 3 — Audience & pricing tests
- Actions:
  - Use remarketing-only ad units on listing pages for recent visitors (higher CPM).
  - Increase ad density on low-conversion informational pages only (guides).
- Experiments:
  - C1: Matched-content units on high-traffic guides vs standard in-article.
  - C2: Price extension vs no price extension on hotel detail (Day 3 add-on).
- KPI: Session RPM, bounce rate, and CVR.

Week 4 — Scale winners & safety net
- Actions:
  - Scale placements that increased RPM with ≤3% CVR drop. Pull back placements which harmed CVR >5% absolute.
  - Finalize site-wide rules and document template flags.
- Experiments:
  - D1: A/B test of ad density reduction on top-performing booking pages to ensure CVR protection.
  - D2: Test different ad sizes (300x250 vs 336x280) in inline-1 for RPM improvement.
- Deliverable: Month‑end report with RPM by category, CTR, session RPM, and conversion impact with recommended steady-state configuration.

KPI Table (example target bands)

| KPI | Week 0 Baseline | Week 4 Target |
|---|---:|---:|
| RPM (site avg USD) | $3.00 | $4.50–7.00 |
| CTR (ads) | 0.6% | 0.8%–1.2% |
| Session RPM | $0.80 | $1.20–$2.50 |
| Booking conversion rate (site) | 1.5% | Maintain ±0.2% (do not drop >10% relative) |

Guardrails for optimization decisions
- If any placement increases RPM but reduces booking CVR by >10% relative → revert placement within 48 hours.
- If CLS >0.10 on pages with new ads → immediately modify placeholders and change ad load strategy.

---

Implementation notes and quick checklist

Immediate technical priorities
- Add page flags for booking and confirmation pages to block ads at template level.
- Implement CSS reserved ad containers for inline slots.
- Configure GTM to lazy-load ad tags with intersection threshold 300px.
- Add Auto Ads URL exclusions for /booking /checkout /payment /thank-you.

Quick deploy checklist (actionable)
1. Add ad slot placeholders and CSS reserved space (per block name) across templates.  
2. Configure GTM to inject ads only when page flag allows and after intersection threshold.  
3. Update AdSense account: create site-level ad units and upload images for PMax if used.  
4. Set Auto Ads: enable Display + In‑article globally; disable Anchor/Interstitial; add URL exclusions.  
5. Run Week 1 tests and collect baseline metrics.

---

If you want I can:
- Produce ready‑to‑paste HTML/CSS snippets for ad-slot placeholders for top-banner inline-1 sidebar-1 and booking suppression rules.
- Generate the exact GTM trigger JSON and sample OpenClaw prompts for each category/page.