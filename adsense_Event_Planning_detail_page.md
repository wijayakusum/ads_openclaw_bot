# AdSense Implementation Plan — Event Planning (Detail Page)  
Site: https://balitatittour.com  
Page: Event planning detail (single event planner or package — description, inclusions, pricing, contact/quote CTA)

Purpose: monetize editorial/detail content while protecting contact/quote conversions and preserving clear price/CTA UX. This is implementation‑ready: placements (named blocks), Auto Ads recommendations, enforceable suppression rules, policy checklist, and a 7‑day verification/test plan with KPI targets.

---

## 1) Placements — block names, sizes, position & rules

Use these canonical block names in templates so analytics and experiments map cleanly. Reserve price/contact areas as no‑ad zones.

| Block name | Position | Sizes | Allowed on detail page? | Notes / Rules |
|---|---:|---:|---:|---|
| hero-banner | Under hero image / title (desktop only) | 728×90 or responsive | Conditional | Desktop only. Render only if contact CTA remains above fold. |
| inline-1 | In‑content after intro / first H2 | 300×250 responsive | Allowed | Primary in‑article unit. Lazy‑load. Keep ≥350px vertical distance from contact/quote CTA. |
| inline-2 | Mid‑article (after H2/H3) for long pages | 300×250 responsive | Conditional | Only for long pages (>800–900 words). One per page. |
| sidebar-1 | Right rail beside price/quote box (desktop only) | 300×250 / 300×600 | Conditional | Desktop only; hide on mobile. Must not overlap contact/quote area. |
| post-content-1 | Below full description, FAQs, reviews | 300×250 responsive | Allowed | Lazy‑load at page end — low interference. |
| mobile-inline | Mobile in‑article (after summary) | 320×100 responsive | Conditional | Only if it does not push CTA below fold. Limit to one mobile ad above fold. |
| sticky-anchor | Mobile sticky footer | 320×50 | NOT recommended | Use only on pure editorial pages without contact CTAs; must be closable and hidden for high‑intent sessions. |
| contact-guard | Reserved no‑ad block around contact/quote CTA & price | N/A | MUST BE NO‑AD | No ads inside or adjacent to this block. |
| confirmation-slot | Thank‑you page only (after confirmation) | responsive small display | NOT on detail | Ads allowed only on thank‑you page, below confirmation message. |

Practical caps:
- Desktop: maximum 2 ad units visible in initial viewport.
- Mobile: maximum 1 ad unit visible in initial viewport.
- Reserve CSS min-height for all ad slots to prevent CLS.

---

## 2) Auto Ads ON / OFF (recommendations)

| Auto Ad format | Global default | Detail page override (Event Planning) | Rationale / Controls |
|---|---:|---:|---|
| Display (responsive) | ON | ON (allowed) | Good for image/text inventory; controlled by page flags. |
| In‑article | ON | ON for long editorial detail pages; OFF for short transactional pages | Use when content length supports ad without hurting CTAs. |
| In‑feed / Matched content | ON if eligible | OFF | Not relevant for single detail pages. |
| Anchor (sticky) | OFF | OFF when contact CTA present; optional ON for informational-only pages (A/B test) | Risk of accidental clicks near CTA. |
| Vignette / Interstitial | OFF | FORCE OFF | Disruptive to reading/booking flow. |
| Auto Ads URL exclusions | — | Exclude /contact /quote /booking and any inline booking endpoints | Prevent Auto Ads on conversion flows. |

Implementation:
- Add a page-level attribute: `data-ads-type="event-detail"` and `data-contact-sensitive="true|false"`. Auto Ads and site ad logic should read these flags.
- Keep Anchor and Vignette OFF by default for pages with `data-contact-sensitive="true"`.

---

## 3) Conversion‑safe suppression zones — enforceable rules

Server‑first enforcement (preferred) with client fallback.

A. Template / server flag
- Add `contact_sensitive = true` to detail pages that include visible contact/quote CTA, price box, or instant booking widget. All ad renderers must check this before rendering.

B. Spatial suppression rules (must enforce)
- **No ad-slot** whose top edge is within **300px vertical** of `.quote-cta`, `.contact-cta`, `.price`, or inline booking widgets.
- `contact-guard` zone (adjacent to price/CTA) is a permanent no‑ad area — do NOT inject ads here.
- `inline-1` must not be placed directly above the contact CTA; ensure minimum **400px** separation.
- Hide `sidebar-1` on mobile.

C. Session & referral suppression
- If user arrives via paid/high‑intent campaign (e.g., `utm_medium=cpc` & campaign includes BOOK/QUOTE), set session flag `ads_suppressed = true` and suppress in-article/in-feed ads for that session (30–60 minutes).
- If user clicks a contact/quote CTA, persist suppression for rest of session.

D. Checkout / contact form pages
- No ads on contact submission/payment pages; block server-side on `/contact`, `/quote`, `/booking` paths.

E. Lazy-load & timing
- Use IntersectionObserver to request ads only when slot is within **400px** of viewport. Above-the-fold allowed if separation rules satisfied.

Developer checklist (must‑do)
1. Set `contact_sensitive` server flag for relevant detail pages.  
2. Server-side: calculate ad insertion points and ensure distance rules before rendering ad HTML.  
3. Client-side fallback: run early script to remove `.ad-slot` elements violating distance.  
4. Store session suppression flag in sessionStorage for paid/referral sessions.

---

## 4) Policy checklist — must follow

Placement & UX
- Never place ads that mimic contact/quote buttons, price tags, or navigation.  
- No ads inside card or contact form elements.  
- Anchor/sticky ads should be disabled for contact‑sensitive pages.

Content & imagery
- Use licensed/owned images. Avoid graphic imagery and add safety disclaimers for risky event activities.  
- Moderate UGC (testimonials/reviews) to remove PII, profanity, and copyrighted content. Label incentivized reviews.

Affiliate & widgets
- If using third‑party booking/contact widgets:
  - Provide clear disclosure near CTA: “Partner service. Commission may apply.”  
  - Do NOT let widgets (iframes) display ads inside their frames. Parent page may show ads only outside widget area.  
  - Ensure data accuracy for prices & availability.

Privacy & consent
- Comply with GDPR/CCPA: do not show personalized ads before required consent.  
- Consent banner must not block contact/quote CTA or hide policies.

Invalid traffic & click safety
- Monitor for CTR spikes on contact/quote pages. High CTR with low conversions suggests accidental clicks or fraud — pause placements and investigate.  
- Implement alerts for unusual CTR/invalid traffic patterns.

Logging & audits
- Log ad slots served and page flags (`contact_sensitive`) per session for correlation with conversion outcomes.

---

## 5) 7‑Day Test Plan with KPI targets

Objective: monetize Event Planning detail pages while maintaining contact/quote conversion performance.

Test design: A/B randomized split (50% Control / 50% Test)
- Control (A): current page with minimal or no ads near CTA.
- Test (B): permitted slots enabled per plan — `inline-1`, `post-content-1`, `sidebar-1` (desktop). `hero-banner` optional for non-contact-sensitive pages. Auto in-article ON where applicable. Session suppression active.

Minimum sample & duration
- 7 days or until **≥3,000 detail pageviews per variant** (adjust to traffic).

Metrics to capture daily
- Detail pageviews  
- Contact/Quote CTA Click-Through Rate (CTA CTR)  
- Contact/Quote conversion rate (CVR) from detail page sessions  
- Page RPM (AdSense)  
- Ad CTR (per-slot)  
- CLS & LCP (page stability)  
- Bounce rate and session duration

KPI targets & action thresholds

| KPI | Baseline | Test target | Action threshold |
|---|---:|---:|---|
| CTA CTR | baseline | No decrease >4% relative | If drop >4% pause Test B immediately |
| Contact/Quote CVR | baseline | No decrease >5% relative | If drop >5% revert placements |
| Page RPM | baseline | +20% uplift desirable | If RPM uplift <10% and CVR drop >2% revert |
| Ad CTR | baseline | Monitor for accidental clicks | If CTR spikes and conversions low → pause slots |
| CLS | baseline | ≤0.10 acceptable | If >0.10 adjust placeholders and defer ad loads |
| LCP (mobile) | baseline | ≤+15% overhead | If >+15% optimize assets or defer ads |
| Bounce rate | baseline | No increase >7% | If increase >7% investigate ad interference |

Day-by-day execution
- **Day 0**: Implement ad placeholders with reserved CSS heights; add `contact_sensitive` flag; implement server-side ad insertion ensuring separation; configure GTM for A/B split and GA4 events: `detail_view`, `contact_cta_click`, `contact_started`, `contact_confirmed`.
- **Day 1 (launch)**: Start 50/50 split. Monitor hourly for first 6–8 hours for script errors, ad disapprovals, and CTR anomalies.
- **Days 2–3**: Review daily metrics. If CTA CTR or CVR shows >3% negative trend, reduce density (remove `sidebar-1` or move `inline-1` lower).
- **Day 4**: Mid-test adjustment based on data.
- **Days 5–6**: Stabilize placements or further reduce density if needed.
- **Day 7**: Final analysis. Accept Test B if **CVR drop ≤5%** and **RPM uplift ≥20%**. Otherwise revert and iterate with lighter density or alternate placements.

Reporting deliverable
- Post‑test summary: RPM change, CTA CTR change, CVR change, per-slot CTR, CLS/LCP deltas, recommended steady-state configuration and next test recommendations.

---

## Developer Handoff — quick snippets & checklist

CSS reserved placeholders
```css
.ad-inline-1 { width:100%; min-height:250px; display:block; }
.ad-sidebar-1 { width:300px; min-height:250px; }
.ad-hero-banner { width:100%; min-height:90px; }
.contact-guard { min-height:120px; /* reserved no-ad zone near contact/price */ }
[data-contact-sensitive="true"] .ad-hero-banner { display:none !important; }
```

Server-side placement logic (pseudo)
```py
# server computes safe insertion points ensuring 2-card separation from contact CTAs
if page.contact_sensitive:
  # restrict top-banner and limit inline placement distance from .contact-cta
  insert_positions = compute_positions(cards, min_distance=2, avoid_contact=True)
else:
  insert_positions = compute_positions(cards)
```

Client-side fallback (early)
```html
<script>
  (function(){
    var contactSensitive = document.body && document.body.dataset && document.body.dataset.contactSensitive === 'true';
    if (contactSensitive) {
      window.ADS_DISABLED_FOR_CONTACT = true;
      document.querySelectorAll('.ad-slot, .adsbygoogle').forEach(n => { try{ n.remove(); } catch(e){} });
    }
    // session suppression for paid referrals
    if (location.search.includes('utm_medium=cpc') && location.search.includes('BOOK')) {
      sessionStorage.setItem('ads_suppressed', '1');
    }
    if (sessionStorage.getItem('ads_suppressed') === '1') {
      document.querySelectorAll('.in-article-ad').forEach(a => a.style.display='none');
    }
  })();
</script>
```

GTM/GA4 events to create
- `detail_view`  
- `contact_cta_click`  
- `contact_started` (form open/submit)  
- `contact_confirmed` (thank-you page)

Logging & monitoring
- Log per ad request: `page_type`, `category`, `contact_sensitive`, `session_source` (utm), `slot_name`, `creative_id` for analysis.

---

If you want, I can:
- Produce ready‑to‑paste HTML/CSS ad slot markup for `inline-1`, `sidebar-1`, `post-content-1`.  
- Generate the GTM container JSON for the A/B split and GA4 event tags for import.  
- Create the GA4 dashboard spec (cards and filters) to monitor KPIs during the 7‑day test.

Which artifact should I prepare next?
