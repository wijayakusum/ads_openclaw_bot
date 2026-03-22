# Day-2 Optimization Pack

## Goal

Improve efficiency after first-day traffic by reducing wasted spend and reallocating budget to high-intent segments.

## Scope

- Search campaigns: brand, booking, ferry
- Ad groups: exact and phrase groups in active campaigns
- Time window: first 24 to 48 hours after launch

## Actions

1. Query search term report and identify irrelevant intent.
2. Add negative terms to shared list using `11_negatives_day2_candidates.csv`.
3. Apply tighter category-specific lists from files `13` to `17`.
4. Check CTR, CPC, conversions, and cost per conversion by campaign and ad group.
5. Apply conservative bid moves in `12_bid_adjustments_day2.csv`.
6. Keep adjustments within +/-15 percent in early learning.

## Category Negative Mapping

- Ferry Ticket Booking: `13_negatives_day2_ferry.csv`
- Hotel Package Stay: `14_negatives_day2_hotel.csv`
- Transfer Service: `15_negatives_day2_transfer.csv`
- Car Rental: `16_negatives_day2_car_rental.csv`
- Tour and Experience: `17_negatives_day2_tours.csv`

Apply each list only to its matching campaign family to avoid over-blocking qualified traffic.

## Decision Rules

- Add negative: if term is clearly irrelevant or repeatedly low intent.
- Decrease bid by 10 to 15 percent: high spend and no conversions.
- Increase bid by 5 to 10 percent: profitable and conversion-driving.
- Hold bid: low data volume or unstable conversion trend.

## Reporting Template

- Date:
- Traffic window reviewed:
- Negatives added count:
- Bid increases count:
- Bid decreases count:
- Highest-impact change:
- Next check time:

## Risk Controls

- Avoid multiple large edits on the same ad group in one day.
- Keep one primary variable change per entity when possible.
- Recheck after 24 hours before next major bid move.
