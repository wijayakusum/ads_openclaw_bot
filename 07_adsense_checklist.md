# AdSense Implementation Checklist — balitatittour.com
Website: https://balitatittour.com  
Site type: Bali travel planner (tours, packages, blog, booking/contact forms)

---

## 1. Pre-Approval Checklist

### Content requirements for travel niche
- Minimum site maturity
  - Minimum page count: 20–30 high-quality pages (DefaultAssumption). Recommended breakdown:
    - 6–12 tour/package detail pages
    - 6–10 evergreen blog posts (destination guides, tips)
    - 1 About page, 1 Contact page, 1 Privacy Policy, 1 Terms/Booking policy, 1 Booking/Packages landing
- Content quality signals
  - Unique, non‑thin content per page (≥600 words recommended for long-form pages; 300–500 words acceptable for package summary if supported by itinerary details and images).
  - Expert/experience signals: author or guide bios, local guide credentials, “Why trust us” section, first‑hand photos, itinerary specifics (duration, inclusions, difficulty).
  - Structured data for tours / LocalBusiness where appropriate (schema.org: Offer, LocalBusiness, Tour).
  - Internal linking and clear navigation to demonstrate site structure.
- Required pages (must be easily discoverable)
  - Privacy Policy (GDPR/CCPA hints if collecting personal data)
  - Terms & Conditions / Booking Policy (cancellation, refunds)
  - Contact page with working email/phone and physical address if available
  - About page explaining who runs the service and credentials
  - Booking/Enquiry form with visible data handling note and link to Privacy Policy
- User trust & transparency
  - Clear pricing or “starting from” indicators (if exact prices unavailable)
  - Reviews/testimonials with source (do not fabricate)
  - Visible phone/contact support during local business hours

### Technical requirements
- HTTPS: site-wide SSL (valid certificate, no mixed content).
- Mobile-friendliness: pass Google Mobile-Friendly test and use responsive design.
- Page speed targets (with ads in mind)
  - Desktop LCP ≤ 2.5s, Mobile LCP ≤ 2.5–3.0s (aim lower).
  - Avoid mobile TTFB spikes; optimize images and server response.
- Accessibility & UX
  - No intrusive popups that block content on first visit (pre-approval will flag aggressive interstitials).
  - Clickable phone numbers and clear form labels.
- No broken links / 4xx pages
  - Run site crawl and fix all 4xx/5xx and redirect chains.
- Robots & sitemap
  - Correct robots.txt (not blocking required pages), up-to-date XML sitemap submitted to Google Search Console.
- Tracking & consent
  - GTM/GA/Ads tags OK, but ensure consent banner if required by location (GDPR). Do not hide privacy policy link in consent UI.

### Policy-safe content rules specific to travel
- Avoid or carefully manage:
  - Sexual content in imagery (no suggestive or adult imagery in travel editorial).
  - Dangerous or illegal activities glamorized (e.g., unlicensed tours that put users at risk). If offering risky activities (volcano climbs, high‑risk water sports), include safety disclaimers and permit info.
  - Misleading claims (e.g., “guaranteed wildlife sightings”).
- Image use
  - Only use licensed/owned images or properly attributed content; don’t use copyrighted images without permission.
  - Avoid graphic or violent imagery.
- Sensitive topics
  - Avoid political or religious persuasion in travel content (keep cultural descriptions factual/respectful).
  - For pages mentioning health/medical advice (altitude, vaccinations), include verbiage that this is informational, not medical advice.
- User-generated content (UGC)
  - If accepting reviews/comments, moderate for profanity, personal data leaks, or copyrighted content. Provide clear moderation policy.
- Booking/Payment
  - If integrating third-party booking widgets or iframes, ensure they do not violate AdSense policy on prohibited content or lead to deceptive practices. Disclose affiliate relationships.

---

## 2. Ad Unit Placement Map (per page type)

Guidelines:
- Max ad units per page: follow AdSense limit and UX best practice (don’t overload). Prioritize content-first layout.
- Keep ad density reasonable on mobile — avoid more ads than core content in the viewport.
- Ensure ad placements do not cover the primary CTA (booking form submit).

Table: recommended ad types, sizes, placement and restrictions

| Page Type | Ad Unit(s) & Sizes | Placement (Above / In-content / Sidebar / Below fold) | Restrictions / Notes |
|---|---:|---|---|
| Homepage | 1 Responsive Display / 1 Leaderboard (728/90 desktop) / 1 Medium Rectangle (300x250) | - Responsive leaderboard hero slot (above fold) if not pushing CTAs down. <br>- 300x250 in right sidebar (desktop) or below hero (mobile). | Avoid auto interstitials on homepage entry. Keep above-fold ad count limited to one prominent unit. |
| Tour / Package Detail page | 1 Responsive In-article (300x250 / 336x280), 1 Responsive leaderboard or large rectangle, optional 1 sticky footer (mobile) | - Leaderboard just below header (above fold on desktop only if content still visible). <br>- In-content unit after first 1–2 content blocks (in-content / in-article). <br>- Sidebar 300x250 (desktop). | Do not place ads inside or covering booking CTA. If sticky footer used, ensure it doesn't obstruct form fields or submit button; add “X” close. |
| Blog Post page (guides / tips) | 1 In-article (300x250) + 1 Inline (responsive) + 1 Sidebar | - In-content after 1st paragraph or after first H2 (above the fold on mobile if short intro). <br>- Secondary in-content after ~400–600 words. <br>- Sidebar 300x250 on desktop. | Avoid multiple in-article ads that interrupt reading; prioritize user experience and time-on-page. |
| Search Results / Listing page | 1 Responsive banner (728/90 desktop) or 1 300x250 below search bar | - Below search filters (below fold preferred). <br>- Avoid ads adjacent to listing action buttons (book/enquire). | Do not mix ads with listing CTA buttons where accidental clicks can occur. Clearly separate ad sections. |
| Contact / Booking Form page | Minimal: 1 small responsive ad below footer or single 300x250 in sidebar (desktop) | - Below-the-fold only. | Strong recommendation: keep page ad-light to avoid distracting from conversions. No anchor or large in-page ads above the form. |
| Thank-You / Confirmation page | 1 Responsive display or 300x250 below confirmation message | - Below the main confirmation message (below fold). | Acceptable to monetize but ensure message clarity (confirmation + next steps) is not obscured by ads. No ads in the header area of the confirmation text. |

Placement best practices
- Maintain visible content-to-ad ratio above the fold — at least half the initial viewport should be content, not ad.
- On mobile, use a single anchor/footer ad max; ensure close button present and does not overlap CTA.
- Avoid placing ads within or adjacent to interactive elements (forms, buttons, carousels) to prevent accidental clicks.

---

## 3. Auto Ads Assessment

Pros and cons for travel planner site
- Pros
  - Fast setup and experiments with multiple ad placements.
  - Google optimizes placements/layouts dynamically by device and user.
  - Good for sites with diverse content types and limited development resources.
- Cons
  - Auto Ads may inject units that shift layout or increase CLS if not configured carefully.
  - Less granular control on exact placement (could be near form CTA or in-content where you’d prefer no ads).
  - Potential to show more ads than is ideal for conversion-focused pages (booking, contact).

Recommendation: Conditional “ON” with selective controls
- Rationale: Use Auto Ads to quickly monetize blog and generic pages, but disable on high-conversion pages (booking/contact) or set manual ad placements there. Auto Ads can be used for Discovery and tuning but must be paired with exclusions.

If ON: recommended Auto Ads formats settings
- Enable:
  - Responsive display (adds contextual units)
  - In-article (for blog post pages)
  - Matched content (if site meets traffic thresholds and has internal linking) — enable only on blog/listing pages
- Disable:
  - Anchor/Sticky ads on Booking / Contact pages (turn off site-wide or exclude specific URLs)
  - Vignette/interstitials on entry to avoid disruption to booking flow (unless used only for blog and after user intent)
  - Auto-placed ads on Thank-You/Confirmation pages? You may allow but place below fold manually
- Use Auto Ads URL exclusions: exclude /booking, /contact, /checkout, /thank-you from Auto Ads if you want full manual control for those pages.

---

## 4. Core Web Vitals & AdSense Compatibility

Targets to maintain with ads active
- LCP (Largest Contentful Paint): ≤ 2.5s (aim ≤ 2s on mobile).
- CLS (Cumulative Layout Shift): ≤ 0.10 (aim ≤ 0.05). Ads are common CLS sources — target lower.
- INP (Interaction to Next Paint) / FID: keep INP responsive — target <200ms where possible.

Lazy-load strategy for ad units
- Lazy-load ads below the fold and only when near viewport (intersection observer).
- For in-article ads: render a placeholder, then load the ad slot when the user scrolls within 300–500px of the slot.
- Avoid lazy-loading above-the-fold ads — they should render immediately.

Anti-CLS recommendations (reserved space / min-height)
- Reserve space with CSS:
  - Use fixed aspect ratio boxes for ads (e.g., style container with aspect-ratio or min-height).
  - Example: .ad-slot { min-height: 250px; width: 100%; } or use aspect-ratio: 300 / 250.
- Use data-ad-size placeholders to maintain layout before ad creative loads.
- For responsive ad units, set CSS containers that adapt but maintain predictable heights per breakpoint.
- Avoid injecting new DOM elements above existing content after load.

Additional technical tips
- Serve GPT / AdSense async scripts to avoid blocking rendering.
- Compress images (WebP), use CDN, preconnect to ad domains if needed.
- Use browser caching and HTTP/2.

---

## 5. Revenue Optimisation (RPM)

Anchor ads
- Recommendation: No by default for travel planner
  - Rationale: Anchor/sticky ads (esp. large mobile sticky) can interfere with form fields and increase accidental clicks on booking pages. Consider only if analytics show high bounce and low page depth on blog pages and after UX testing.

Interstitials
- Recommendation: No on booking/contact/thank-you pages. Consider limited use on blog for engagement if configured as exit or after significant engagement (e.g., after 45–60s).
  - Timing: If used on blog, show as exit intent or after 60+ seconds and ensure easy dismissal.

In-feed vs In-article
- In-article: excellent fit for blog posts and long-form guides — good RPM and user engagement.
- In-feed: use on listing pages if you have natural listing feed (e.g., “Other tours” or suggestions) — better user experience than ad-heavy sidebars.
- Recommendation: use in-article for blog posts, and in-feed for tours listing pages if layouts support it.

A/B test plan (two specific tests)
- Test A — In-content ad position vs later position
  - Hypothesis: An in-article ad placed after the first H2 will increase RPM without significantly reducing micro-conversions (enquiry clicks).
  - Setup: Randomly serve version A (ad after intro) vs version B (ad after 600 words) on blog pages for 2–4 weeks. Track CVR (form submits), bounce rate, and RPM.
- Test B — Sticky footer ad vs no sticky ad on mobile (on informational pages only)
  - Hypothesis: Sticky footer increases RPM but may reduce time on site or micro-conversions slightly.
  - Setup: Serve sticky footer to 50% of mobile blog traffic, compare RPM and booking enquiry rate. Ensure sticky has an obvious close button.

---

## 6. Policy Compliance Ongoing Checklist

Monthly review items
- Content review:
  - Review new pages for quality and policy compliance (no copyrighted images, no disallowed content).
  - Check UGC (reviews/comments) for policy violations.
- Technical & Ads:
  - Verify ad placements haven’t shifted into CTAs or forms due to layout changes.
  - Review Auto Ads placement logs and blocked URLs list.
- Traffic quality:
  - Check for sudden spikes from unknown referrers; validate real users (use GSC & GA).
  - Monitor invalid traffic (Google Ads / AdSense reports) and take action on suspicious IPs.
- Revenue & UX:
  - RPM trends vs conversion trends (if RPM rises dramatically but conversions drop, reassess placements).
- Privacy & Consent:
  - Verify consent banner functional and that ads are gated for EU consent if necessary.

Content categories to avoid / travel-specific gotchas
- User-generated reviews:
  - If publishing UGC reviews, moderate for profanity, personal data, or copyrighted content.
  - Clearly label promotional or incentivised reviews. Avoid fake or paid reviews without disclosure.
- Affiliate links & booking iframes:
  - Affiliate links are allowed if disclosed and non-deceptive. Do not cloak affiliate links or misrepresent prices.
  - Iframes for booking that obscure content or contain deceptive claims may be flagged — ensure transparent labeling and that parent page contains primary content.
- Thin/seasonal pages:
  - Don’t create many low-value seasonal pages (e.g., “Bali 2026 events” with only a calendar link). Consolidate seasonal info into evergreen pages or roll up into single hub pages.
  - If seasonal content is thin, either enrich it (details, images, logistics) or keep it noindex until expanded.
- Deceptive or high-risk claims:
  - No guaranteed refunds/promises unless backed by policy and clear T&Cs.

Handling thin/seasonal content without policy risk
- Strategy:
  - Combine thin or seasonal content into comprehensive guides (e.g., “Bali Waterfalls & Seasonal Tips”) rather than many short pages.
  - Use canonical tags to consolidate duplicate/near-duplicate content.
  - Mark thin pages as noindex until enriched.
  - Add value: local tips, exact logistics, accessibility notes, best months, safety considerations, sample itineraries.

---

## 7. AdSense + Google Ads (dual running) notes

Publisher vs advertiser account separation
- Maintain clear separation:
  - Publisher (AdSense) account used only for serving ads and collecting revenue.
  - Advertiser (Google Ads) account used for buying ads. Do not use the same login for automated actions that could blur roles — keep billing/contacts separate where possible.
- AdSense policy: Do not click your own ads or use Google Ads to inflate publisher revenue with your own placements.

Avoiding self-click / accidental interaction issues
- Strict rules:
  - When running Google Ads that point to your own site, ensure ad creatives and landing page design minimize accidental ad clicks (e.g., avoid placing Google Ads immediately adjacent to CTA buttons used by paid landing pages).
  - Use placement controls to avoid showing publisher ad units on the same pages used in paid campaigns if those pages are configured to encourage ad clicks (dangerous mix).
  - Do not run campaigns that incentivize clicks on publisher ads (explicitly disallowed).
- Monitoring:
  - Regularly check AdSense invalid activity reports and your Google Ads click patterns. If suspicious clicks happen, pause relevant campaigns and investigate.

---

## Quick-Start Steps (in order)

1. Audit content for policy compliance: ensure Privacy Policy, Terms, About, Contact pages exist and are visible.
2. Fix technical basics: site-wide HTTPS, mobile responsive checks, fix broken links, install sitemap & robots.
3. Prepare 20–30 quality pages (tours, packages, 6+ blog posts); enrich thin pages.
4. Implement GTM / GA4 and privacy consent; ensure booking form submissions and phone clicks are tracked.
5. Create or verify schema for tours & LocalBusiness.
6. Design ad placements:
   - Add manual ad slots for: homepage hero (if used), tour detail in-content, blog in-article; keep booking/contact pages ad-light.
7. Configure AdSense account and follow site association steps; while awaiting approval, keep content and technical fixes active.
8. If using Auto Ads, enable only In-Article and Responsive on blog/listing pages; exclude booking/contact/thank-you URLs.
9. Implement reserved ad space containers (CSS min-height) to prevent CLS.
10. Launch AdSense test: add one or two ad units on blog and one ad on a tour page; monitor CLS and load metrics.
11. Run A/B tests:
    - Test in-article position vs lower down for blog pages.
    - Test sticky footer vs no sticky (mobile, informational pages only).
12. Monthly checks: content moderation, policy review, traffic quality, and RPM vs CVR tradeoffs.

---

If you want, I can:
- Produce ready-to-implement CSS snippets for ad-slot placeholders (responsive + min-height).
- Generate a prioritized list of 10 pages to monetize first (based on likely traffic/conversion).
- Provide an AdSense-ready HTML sample for a Tour Detail page showing recommended placements.