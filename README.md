# BaliTatiTour Google Ads and AdSense Pack

This repository contains launch-ready Google Ads artifacts and AdSense planning assets for balitatittour.com.

## What is Included

- Day-1 import-ready CSV files for campaigns, ad groups, keywords, negatives, RSAs, and extensions.
- AdSense setup checklist and page-level rollout plans by category.
- Day-2 optimization pack for early performance tuning.

## Core Files

- `01_campaigns_day1_import_ready.csv`
- `02_ad_groups_day1_import_ready.csv`
- `03_keywords_day1_import_ready.csv`
- `04_negatives_shared_day1_import_ready.csv`
- `05_rsa_ads_day1_import_ready.csv`
- `06_extensions_day1_import_ready.csv`
- `07_adsense_checklist.md`
- `08_day1_launch.md`
- `09_adsense_6_categories_plan.md`
- `10_day2_optimization_pack.md`
- `11_negatives_day2_candidates.csv`
- `12_bid_adjustments_day2.csv`
- `13_negatives_day2_ferry.csv`
- `14_negatives_day2_hotel.csv`
- `15_negatives_day2_transfer.csv`
- `16_negatives_day2_car_rental.csv`
- `17_negatives_day2_tours.csv`

## Import Order (Google Ads Editor)

1. Campaigns
2. Ad groups
3. Keywords
4. Negative keywords and shared lists
5. RSA ads
6. Extensions

Use the matching `*_day1_import_ready.csv` files in this sequence.

## Day-2 Optimization Workflow

1. Pull search terms from the first 24 hours.
2. Add irrelevant terms into `11_negatives_day2_candidates.csv` and upload as negatives.
3. Apply category-level negatives from files `13` to `17` to the matching campaign groups.
4. Review campaign and ad-group performance.
5. Apply controlled bid changes from `12_bid_adjustments_day2.csv`.
6. Track what was changed and why in `10_day2_optimization_pack.md`.

## Quick Commands

```bash
git status
git pull --rebase origin main
```

## Notes

- Keep all CSV files in UTF-8 and comma-delimited format.
- Validate character limits in Google Ads before final publish.
- Apply bid changes gradually in early learning phase.
