# AdSense Implementation Plan — Ferry Ticket Booking (Checkout Page)  
Site: https://balitatittour.com  
Page: Checkout / Payment / Seat selection (the page where user enters passenger details, payment, confirms booking)

Summary: Checkout pages are conversion‑critical and high‑risk for accidental ad clicks. The implementation below treats checkout pages as ad‑free by default, with strict guardrails if any low-impact messaging is required (e.g., informational non‑ad content). Follow server‑side suppression first; client‑side checks are fallback.

---

1) Placements (block names) — recommended action: NO ADS on checkout page
- Recommended: No ad units on checkout pages. All ad slots disabled server‑side.
- Reserved block names (for templates / logging) — keep as non‑ad placeholders only:
  - confirmation-hero (reserved non‑ad content)
  - price-summary-guard (reserved non‑ad area around price)
  - checkout-form (primary booking form container)
  - post-confirmation-slot (ONLY used on thank‑you page, not checkout)
- If business insists on a low‑risk informational message (recommendation only):
  - info-inline — small site-owned info block (NOT an ad) below fold, after payment success or as “help” content; do NOT render any ad creatives here.

Table — placement policy
| Block name | Allowed? | Notes |
|---|---:|---|
| confirmation-hero | Allowed (non-ad only) | Use for heading; no ads |
| price-summary-guard | Allowed (non-ad) | Reserved; no ads can be placed here |
| checkout-form | Forbidden for ads | Never place ads inside or adjacent to payment controls |
| post-confirmation-slot | Allowed only on confirmation page (not checkout) | Ads allowed below confirmation message on thank‑you only |
| info-inline | Allowed (non-ad informational only) | If used, must be site‑owned content without third‑party ad creatives |

Rationale: Checkout pages must be free of any Google AdSense ad units to avoid accidental clicks, policy issues, and conversion harm.

---

2) Auto Ads — ON / OFF guidance

| Auto ad format | Recommendation for checkout page |
|---|---|
| Display (responsive) | OFF — exclude checkout URL(s) from Auto Ads |
| In‑article | OFF |
| In‑feed / Matched content | OFF |
| Anchor (sticky) | OFF — must be globally disabled for checkout flows |
| Vignette / Interstitial | OFF — never on checkout pages |
| Auto Ads URL exclusions | REQUIRED — add all checkout endpoints (/checkout /booking /payment /seat-select /payment-confirm) to Auto Ads exclusion list |

Action items
- In AdSense Auto Ads settings, add URL patterns for all checkout and payment related pages to the exclusions list.
- Ensure Auto Ads global anchor/vignette are disabled or don’t run on the domain paths used by checkout.

---

3) Conversion‑safe suppression zones — exact rules

Implement server‑side suppression first (preferred), then client‑side fallback.

A. Server‑side suppression (MUST)
- All ad rendering code must check `isCheckoutPage = true` before returning any ad slot HTML. If true, return no ad tags.
- Blocklist / route matching: `/checkout`, `/booking`, `/payment`, `/seat-select`, `/confirm`, `/payment-confirmation` (adjust to real site paths).

B. Client‑side double-check (fallback)
- On pages where server flag is missing, run JS early in page load:
  - If `document.body.dataset.pageType === 'checkout'` then remove/hide any `.ad-slot` elements before ad code executes.
  - Immediately stop any ad network tag execution for that page.

C. Session & referral rules
- For pages in payment flow, maintain `ads_suppressed = true` in sessionStorage; any subsequent navigations to checkout or payment must preserve suppression until thank‑you page.

D. Post‑payment (thank‑you) behavior
- On the thank‑you / confirmation page you may allow one conservative ad block below the confirmation text (post-confirmation-slot) — but only after waiting for at least one second and ensuring it does not look like the confirmation or next steps CTA.
- Even on confirmation pages, prefer site-owned upsell links (private content) over third‑party ads if conversion/research priorities demand.

Developer checklist (server + client)
1. Add `isCheckoutPage` boolean to server template context for all checkout/payment routes.  
2. If `isCheckoutPage === true`, do not render any ad placeholders or ad script tags.  
3. Client-side sanity: at top of page, run a script to remove `.ad-slot` and prevent network ad requests if server flag absent.  
4. Ensure Auto Ads exclusions configured for checkout URL patterns.

Example server logic (pseudocode)
```py
if route in ['/checkout','/payment','/seat-select']:
  page.isCheckoutPage = True
else:
  page.isCheckoutPage = False
# Template:
if not page.isCheckoutPage:
  render_ad_slots()
```

---

4) Policy checklist — must follow on checkout pages

Hard rules
- NO AdSense creatives or third‑party paid ads on checkout, payment, or seat selection pages.
- NO anchor/sticky ads that can overlap form fields or payment buttons.
- NO interstitials that interrupt the payment path.

UX & legal
- Price, taxes, fees, refund policy, cancellation policy must be visible and accurate near payment controls; do not place ads nearby.
- Consent/Privacy: ensure consent UI (if required) does not hide payment controls and does not block checkout.

Affiliate / third‑party widgets
- If checkout uses third‑party hosted payment iframe:
  - Parent page must not include ads that could be confused with payment UI.
  - Do not allow the iframe to inject ads via its source.

Security & compliance
- All checkout pages must use HTTPS and display secure payment indicators; do not tamper with these signals via ad code or scripts.

AdSense policy alignment
- Serving ads on a page that may cause accidental clicks leading to revenue from users seeking to complete a transaction is a policy and UX risk; the safe path is no ads.

Monitoring & logging
- Log any attempt to render an ad on checkout pages with error alerts; block immediately and notify site admin.

---

5) 7‑Day Test Plan with KPI targets (focus: verify zero‑ads policy and monitor conversion health)

Goal: verify checkout pages are ad‑free, ensure no Auto Ads leakage, and confirm conversion metrics stable after enforcing suppression.

Test design: Enforcement + verification (not an A/B with ads). We are validating that removing ads (if previously present) has no negative effects and that no ad injection occurs.

Duration: 7 days monitoring after deployment.

Metrics & checks (daily)
- 1) Ad requests on checkout pages (count per day) — target: 0  
- 2) Page RPM on site (overall) — expect slight decrease vs pre-change if ads previously showed on checkout; record delta  
- 3) Checkout page conversions (booking completed) — target: no decrease (ideally stable or increase)  
- 4) Drop-offs on payment step (abandonment rate) — target: decrease or unchanged  
- 5) Auto Ads reports — ensure excluded pages show 0 auto placements  
- 6) Page load metrics (LCP, CLS) on checkout pages — target: improve or unchanged

KPI table — acceptance & action thresholds

| KPI | Baseline (pre-change) | Day 7 target | Action threshold |
|---|---:|---:|---|
| Ad requests on checkout pages | baseline value | 0 | >0 → immediate investigation and disable Auto Ads / ad scripts |
| Booking conversion rate (CVR) on checkout | baseline | ≥ baseline (no drop) | drop >3% → roll back and debug other changes |
| Checkout abandonment rate | baseline | ≤ baseline (preferred) | increase >5% → investigate for UX issues unrelated to ads |
| Auto Ads placements on checkout (AdSense) | baseline | 0 placements | >0 → confirm URL exclusion and page flags |
| LCP / CLS on checkout pages | baseline | not worse than +10% | larger degradation → optimize assets and remove any heavy script |

Day-by-day plan
- Day 0 (deploy): Implement server-side suppression for checkout routes; add client-side guard as fallback; configure Auto Ads exclusions for checkout URL patterns.
- Day 1: Verify via network logs (DevTools / server logs) that no ad network calls initiated on checkout pages. Confirm Auto Ads console shows excluded URLs.
- Days 2–3: Monitor bookings & abandonment metrics hourly for first 48 hours, then daily. Ensure no regression vs baseline.
- Days 4–6: Continue monitoring; inspect logs for any unexpected ad tags or third‑party scripts firing. Validate session suppression persists across redirect flows.
- Day 7: Produce short report: ad requests = 0 (pass), conversions vs baseline, abandonment, LCP/CLS. If any ad requests found, block domain-level ad scripts immediately and re-audit.

Emergency actions (if ad leakage detected)
1. Disable Auto Ads globally while investigating (AdSense UI).  
2. Remove/disable any ad-injecting scripts from page templates.  
3. Push hotfix to server-side suppression (isCheckoutPage flag) to return early and block all ad HTML.  
4. Notify stakeholders and open incident root cause.

---

Implementation checklist (developer handoff)

1. Identify all checkout/payment route patterns and set server flag `isCheckoutPage = true`.  
2. Remove any ad slot rendering from templates when `isCheckoutPage === true`.  
3. Add client-side guard as a fallback that removes `.ad-slot` and prevents ad scripts from executing early in the load lifecycle.  
4. Configure AdSense Auto Ads exclusions for all checkout/payment URL patterns.  
5. Add logging/alert: if any ad request to ad networks originates from a checkout URL, send immediate alert to ops.  
6. Run smoke test: open checkout page in incognito, inspect Network tab for any ad calls (adsense, googlesyndication, gpt, etc.) — must be zero.  
7. Monitor production for 7 days per test plan and report.

---

If you want, I can produce:
- Ready-to-paste server template snippet (pseudocode) to block ad slot rendering.  
- Client-side guard snippet that must run before ad network scripts.  
- AdSense Auto Ads exclusion list lines to paste into the AdSense UI.  

Which of those would you like next?
