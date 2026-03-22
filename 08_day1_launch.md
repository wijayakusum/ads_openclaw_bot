# Day 1 — 60‑minute Google Ads Launch Guide  
Site: https://balitatittour.com  
Day‑1 campaigns to launch:  
- CONV_SEARCH_AU_BRAND_20260322 — Brand — $10/day — Maximize Clicks  
- CONV_SEARCH_AU_BOOKING_20260322 — Booking Intent — $7/day — Maximize Clicks  
- CONV_PMAX_GLOBAL_ALLPACKAGES_20260322 — Performance Max — $36/day — Maximize Conversions  
Total daily budget = $53. Other Search campaigns (CUSTOM etc.) launch Day 3 after tracking verification.

Follow each timed block exactly. Everything is copy‑paste ready.

---

T‑0 — Pre‑Launch (0–15 min)

A. GTM container setup — numbered, copy/paste ready
1. Open Google Tag Manager → Workspace → Click “New” → Name: GA4 Configuration.  
2. Tag Configuration → Google Analytics: GA4 Configuration → Measurement ID: G-XXXXXXXX (replace with your GA4 ID). Trigger: All Pages → Save.  
3. New Tag → Name: GA4 Event — form_submit  
   - Tag Type: Google Analytics: GA4 Event  
   - Configuration Tag: GA4 Configuration  
   - Event Name: form_submit  
   - Event Parameters (optional): form_id = {{Form ID}}  
   - Trigger: Form Submission Trigger (see step 6) → Save.  
4. New Tag → Name: GA4 Event — phone_click  
   - Tag Type: Google Analytics: GA4 Event  
   - Configuration Tag: GA4 Configuration  
   - Event Name: phone_click  
   - Trigger: Click — Just Links → Trigger Conditions: Click URL contains tel: → Save.  
5. New Tag → Name: GA4 Event — booking_confirm  
   - Tag Type: Google Analytics: GA4 Event  
   - Configuration Tag: GA4 Configuration  
   - Event Name: booking_confirm  
   - Trigger: Page View → Page Path contains /thank-you OR equals /thank-you (use actual thank‑you URL) → Save.  
6. Create Form Submission Trigger (two quick options):  
   - If the form redirects to a Thank‑You page: rely on booking_confirm trigger (step 5).  
   - If the form uses AJAX (no redirect): Trigger → New → Trigger Type: Form Submission OR Custom Event (match event name pushed by site). If unsure, use DOM Element Visibility targeting the element that appears on success.  
7. Preview (GTM Preview Mode) and test on staging or production pages: submit form, click phone link, confirm events fire.  
8. Publish GTM container: Submit → Publish.

B. GA4 events & GTM trigger summary (copy)
- form_submit → Trigger: Form Submission success OR fallback to /thank-you page view.  
- phone_click → Trigger: Click — Just Links where Click URL contains tel:.  
- booking_confirm → Trigger: Page view where path contains /thank-you.

C. Google Ads conversion actions — create (Ads → Tools & Settings → Conversions)
- Conversion name: GA4_form_submit  
  - Category: Lead | Count: One | Value: No (or set default) | Conversion window: 30 days | Attribution: Data‑driven (if available) or Last click.
- Conversion name: GA4_phone_click  
  - Category: Phone calls | Count: One | Value: No | Window: 30 days | Attribution: Last click.
- Conversion name: GA4_booking_confirm  
  - Category: Purchase (or Lead if no revenue) | Count: One | Value: Use revenue if available else No | Window: 30 days | Attribution: Data‑driven.

Note: If using GA4 events → mark these events as conversions in GA4 and then import into Google Ads (Conversions → Import → Google Analytics 4).

---

T‑15 — Google Ads Account Setup (15–25 min)

A. Account basics (copy-paste)
- Currency: USD (or your billing currency)  
- Time zone: UTC+8 (Asia/Makassar — Bali local)  
- Billing threshold recommendation: leave default; enable email billing alerts; monitor first week manually. Consider small prepaid top‑up if using automatic billing.

B. Link GA4 → Google Ads (exact menu path)
1. Google Ads → Tools & Settings (top right) → Setup → Linked accounts.  
2. Click “Google Analytics (GA4)” → Select property → Link → choose data streams and conversions → Save.

C. Remarketing audiences (create in GA4; import to Ads)
1. GA4 → Configure → Audiences → New audience:  
   - All Visitors 0–30d → membership duration = 30 days.  
   - Booking Page Visitors 0–14d → condition: page_path contains /booking OR page_view where page_path = /booking → membership duration 14 days.  
2. Wait for audiences to populate (may take hours). Verify in Google Ads → Tools → Audience Manager.

---

T‑25 — Campaign Build (25–45 min — 20 min)

General settings to check for all campaigns:
- Locations: Australia (Search campaigns), PMax: choose Global or AU (recommended to start AU only if you want tighter control).  
- Languages: English.  
- Networks (Search campaigns): uncheck Display & Search Partners (conservative).  
- Ad schedule: All days/all hours.  
- Final URL suffix / UTM: optional utm_source=google&utm_medium=cpc&utm_campaign={campaignid}&utm_term={keyword}&utm_content={adid}.

A. CONV_SEARCH_AU_BRAND_20260322 — Brand
1. Campaign type: Search. Campaign name: CONV_SEARCH_AU_BRAND_20260322.  
2. Daily budget: $10. Bidding: Maximize Clicks.  
3. Networks: Google Search only (uncheck Display & Search Partners).  
4. Locations: Australia. Languages: English.  
5. Ad group: BRAND_MAIN.  
6. Keywords (copy/paste with match types):
   - [balitatittour]  
   - "balitatittour"  
   - [balitatit tour]  
   - "balitatit tour"  
   - [balitatittour booking]
7. RSA (Responsive Search Ad) — paste into RSA creation:
   - Headlines (use up to 15; providing top 5 now):  
     - BalitatitTour  
     - Book BalitatitTour Now  
     - Trusted Bali Travel Planner  
     - Private Bali Guides & Tours  
     - Instant Booking Confirmation  
   - Descriptions (2):  
     - Personalized Bali tours and local guides. Enquire for 4D3N packages.  
     - Fast booking & 24/7 local support. Start your Bali itinerary today.  
8. Final URL: https://balitatittour.com (or a brand landing page).

B. CONV_SEARCH_AU_BOOKING_20260322 — Booking Intent
1. Campaign type: Search. Campaign name: CONV_SEARCH_AU_BOOKING_20260322.  
2. Daily budget: $7. Bidding: Maximize Clicks.  
3. Networks: Search only. Locations: Australia. Languages: English.  
4. Ad group: BOOKING_MAIN.  
5. Keywords:
   - "book bali tour"  
   - [bali tour booking]  
   - "book bali day tours"  
   - [bali tour packages book]  
   - "book mount batur sunrise"
6. RSA (1 ad) — paste:
   - Headlines:  
     - Book Bali Tours Today  
     - Instant Tour Booking  
     - Secure Your Bali Dates  
     - Professional Bali Planner  
     - Enquire & Reserve Now  
   - Descriptions:  
     - Quick booking for Bali tours — secure your spot and get confirmation.  
     - Forms, phone or email — we handle transfers and guides.  
7. Final URL: booking landing page (e.g., https://balitatittour.com/book or specific booking URL).

C. CONV_PMAX_GLOBAL_ALLPACKAGES_20260322 — Performance Max
1. Campaign type: Performance Max. Name: CONV_PMAX_GLOBAL_ALLPACKAGES_20260322.  
2. Daily budget: $36. Bidding: Maximize Conversions (select primary conversion = GA4_form_submit or booking_confirm).  
3. Locations: Recommended start = Australia (match Search). If you prefer Global, be prepared for wider reach. Languages: English.  
4. Asset group — required assets checklist (collect and upload):
   - Final URL: https://balitatittour.com  
   - Short headlines (up to 5):  
     - Bali Travel Planner  
     - Custom Bali Tours  
     - Book East Bali Tours  
     - Hidden Waterfall Trips  
     - Sunrise Trekking Bali  
   - Long headline: Tailor-Made Bali Tours & Local Guides  
   - Descriptions (2–4):  
     - Personalized 4D3N Bali itineraries — private or small groups.  
     - Book waterfall treks, sunrise hikes, and custom packages today.  
   - Images: at least 1 landscape (1200×628) and 1 square (1200×1200).  
   - Logos: at least 1 square (400×400).  
   - Videos: optional (skip if unavailable). PMax will run without video.  
   - Business name: BaliTatitTour. CTA: Book Now / Contact Us.  
5. Audience signals (optional but recommended): In‑market Travel, custom intent keywords: bali tours, book bali tour; remarketing lists if available.  
6. Enable automated extensions & asset optimization.

Network & checkboxes
- Search campaigns: ensure “Include Google search partners” is OFF (unchecked) for Day 1 if you want control.  
- PMax: no manual network checkboxes; leave defaults.

---

T‑45 — Extensions (45–50 min — 5 min)

A. Sitelinks (6) — add to Search campaigns (copy/paste)
- East Bali Tours — 4D3N East Bali packages & hidden waterfalls  
- Waterfall Treks — Sekumpul, Tibumana & secret cascades  
- Sunrise Treks — Mount Batur & Agung sunrise hikes  
- Custom Itineraries — Build your private Bali trip  
- Private Tours — Guides, driver & transfers included  
- Book Now — Check availability & secure your dates

B. Callouts (5) — copy/paste
- Local English Guides  
- Private Transfers Included  
- Small Group Options  
- Flexible Cancellations  
- 24/7 Local Support

Skip structured snippets and price extensions for Day 1 (add Day 3).

---

T‑50 — Pre‑Go‑Live Verification (50–55 min — 5 min)

A. 8‑point checklist (tick before enabling campaigns)
1. GTM published and GA4 Configuration tag present (Tag Assistant or preview).  
2. GA4 events fire on test (form_submit, phone_click, booking_confirm) — check GA4 Realtime.  
3. Google Ads linked to GA4 (Tools → Linked accounts).  
4. Conversion actions created or GA4 import set up in Google Ads.  
5. Campaign budgets set to $10 / $7 / $36.  
6. Locations set to Australia for Search; PMax location set as decided.  
7. RSA final URLs load and forms/phone links work.  
8. Minimal negative keywords added: free, jobs, cheap flights, flights, airline, hostel.

B. Test search without wasting real impressions
- Use Ad Preview & Diagnosis: Google Ads → Tools & Settings → Ad Preview & Diagnosis → Enter keyword (e.g., balitatittour or "book bali tour"), location = Australia, language = English → view preview. (This does not generate impressions.)

C. Google Tag Assistant verification steps (quick)
1. Open Chrome → install/use Tag Assistant or use GA DebugView.  
2. Open site in incognito (with GTM preview) → perform a form submit or open /thank-you; click tel: link.  
3. In GA4 → Realtime events view → confirm form_submit / phone_click / booking_confirm appear.

---

T‑55 → First 4 Hours Monitoring (post‑Enable)

A. What to check every 30 minutes (first 4 hours)
1. Impressions & clicks per campaign (Campaigns → Overview).  
2. Search terms (Keywords → Search terms) → add negatives for irrelevant queries.  
3. Conversions in GA4 Realtime and Google Ads conversions column.  
4. CTR & avg CPC — flag very low CTR (0–0.2%) or unexpectedly high CPC.  
5. Ad status & disapprovals (Ads & assets).  
6. Spend vs daily budget (Billing & Overview).

B. Pause thresholds — immediate manual actions
- Pause a keyword if: Spend ≥ $10 AND Conversions = 0 AND CTR < 0.2% OR search term is irrelevant.  
- Pause an ad if: Ad disapproved OR CTR < 0.2% after ≥200 impressions.  
- Pause PMax asset if: asset disapproved or flagged by policy.

C. Emergency stop — pause all campaigns in <30 seconds
1. Google Ads → Campaigns → top-left checkbox (select all campaigns) → Click “Pause” (blue toolbar). This immediately pauses all campaigns.  
2. Alternative: From the Overview page, use the campaign-level toggle to pause each campaign quickly.

---

Quick copy-paste blocks (RSA / keywords / extensions)

RSA — Brand (paste into RSA fields)
- Headlines:
  - BalitatitTour
  - Book BalitatitTour Now
  - Trusted Bali Travel Planner
  - Private Bali Guides & Tours
  - Instant Booking Confirmation
- Descriptions:
  - Personalized Bali tours and local guides. Enquire for 4D3N packages.
  - Fast booking & 24/7 local support. Start your Bali itinerary today.

RSA — Booking (paste into RSA fields)
- Headlines:
  - Book Bali Tours Today
  - Instant Tour Booking
  - Secure Your Bali Dates
  - Professional Bali Planner
  - Enquire & Reserve Now
- Descriptions:
  - Quick booking for Bali tours — secure your spot and get confirmation.
  - Forms, phone or email — we handle transfers and guides.

Keywords — BRAND_MAIN
- [balitatittour]  
- "balitatittour"  
- [balitatit tour]  
- "balitatit tour"  
- [balitatittour booking]

Keywords — BOOKING_MAIN
- "book bali tour"  
- [bali tour booking]  
- "book bali day tours"  
- [bali tour packages book]  
- "book mount batur sunrise"

Minimal negative keywords (add shared negatives now)
- free  
- jobs  
- cheap flights  
- flights  
- airline  
- hostel

Sitelinks (paste)
- East Bali Tours — 4D3N East Bali packages & hidden waterfalls  
- Waterfall Treks — Sekumpul, Tibumana & secret cascades  
- Sunrise Treks — Mount Batur & Agung sunrise hikes  
- Custom Itineraries — Build your private Bali trip  
- Private Tours — Guides, driver & transfers included  
- Book Now — Check availability & secure your dates

Callouts (paste)
- Local English Guides  
- Private Transfers Included  
- Small Group Options  
- Flexible Cancellations  
- 24/7 Local Support

---

After Day‑1 launch
- Monitor closely for 48–72 hours. Confirm conversions are tracking and stable. If GA4 → Ads import shows conversions, prepare to launch remaining Search campaigns (CUSTOM etc.) on Day 3.  
- If you want, I can prepare a Google Ads Editor import file for these 3 campaigns to speed the creation step.

Good luck — enable campaigns when ready and follow the 30‑minute checks for the first 4 hours.