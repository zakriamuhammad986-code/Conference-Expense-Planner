# Conference Expense Planner

A React + Redux Toolkit front end for pricing out a conference: pick rooms,
add-ons, and meal headcounts, then review a running total in a "Show
details" pop-up.

## Run it

```bash
npm install
npm start
```

Opens at `http://localhost:3000`. `/` is the landing page, `/plan` is the
product selection page.

## Structure

```
src/
  app/store.js                Redux store, combines the three slices
  data/products.js            Room, add-on, and meal price data (edit here to change pricing)
  features/
    rooms/roomsSlice.js        room quantities + selectors (line items, subtotal)
    addOns/addOnsSlice.js      AV equipment quantities + selectors
    meals/mealsSlice.js        per-meal headcounts + selectors
  components/
    LandingPage.jsx            hero + "Get started" entry point
    Header.jsx                 sticky nav + "Show details" trigger
    QuantityStepper.jsx        shared +/- control for rooms and add-ons
    RoomsSection.jsx / AddOnsSection.jsx / MealsSection.jsx
    SummaryModal.jsx           pop-up: 4-column table (item, unit cost, qty, subtotal) + total
  pages/ProductSelectionPage.jsx   assembles header + the three sections + modal
  utils/pricing.js             formatCurrency helper
```

## Notes on the implementation

- Each product category is its own Redux slice, matching the "slices" pattern
  called out in the assignment. Selectors (e.g. `selectRoomLineItems`,
  `selectRoomsTotal`) live next to each slice so pricing math isn't
  duplicated in components.
- Rooms and add-ons use increment/decrement steppers; meals use a number
  input for headcount, per the spec.
- The summary modal pulls line items from all three slices, filters out
  anything with a zero quantity, and sums the three category totals for the
  grand total.
- Swap in real photography for the landing page hero by replacing the
  `.landing__visual` block in `LandingPage.jsx` — it's currently a CSS-drawn
  seat map so the project runs with no image assets.
- To reuse this structure for the final project (a plant shopping cart), the
  same shape applies: one slice per data domain, `products` array driving a
  `map()`-rendered list, and a shared subtotal/total selector pattern.
