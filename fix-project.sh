#!/usr/bin/env bash
set -e
echo 'Fixing project structure...'

# Move existing flat files into place
mkdir -p public src
[ -f index.html ] && mv -f index.html public/index.html || true
[ -f App.js ] && mv -f App.js src/App.js || true
[ -f index.js ] && mv -f index.js src/index.js || true
[ -f index.css ] && mv -f index.css src/index.css || true

mkdir -p src/app src/data src/utils src/components src/pages src/features/rooms src/features/addOns src/features/meals

echo 'Writing public/index.html'
cat > public/index.html << 'FILEEOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Assemblage &mdash; Conference Expense Planner</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,400&family=IBM+Plex+Sans:wght@400;500;600&display=swap"
      rel="stylesheet"
    />
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
FILEEOF

echo 'Writing src/index.js'
cat > src/index.js << 'FILEEOF'
import React from "react";
import ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import { BrowserRouter } from "react-router-dom";
import "./index.css";
import App from "./App";
import { store } from "./app/store";

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <Provider store={store}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </Provider>
  </React.StrictMode>
);
FILEEOF

echo 'Writing src/index.css'
cat > src/index.css << 'FILEEOF'
:root {
  --ink: #1b2430;
  --ink-soft: #2e3a4a;
  --paper: #f7f5f0;
  --paper-raised: #ffffff;
  --brass: #ad7f34;
  --brass-dark: #8c6427;
  --slate: #5b6b7a;
  --line: #ddd5c4;
  --line-strong: #c7bca4;
  --danger: #9c3b2e;

  --font-display: "Newsreader", Georgia, serif;
  --font-body: "IBM Plex Sans", -apple-system, BlinkMacSystemFont, sans-serif;

  --space-1: 0.5rem;
  --space-2: 1rem;
  --space-3: 1.5rem;
  --space-4: 2.5rem;
  --space-5: 4rem;
}

* {
  box-sizing: border-box;
}

html,
body {
  margin: 0;
  padding: 0;
}

body {
  background: var(--paper);
  color: var(--ink);
  font-family: var(--font-body);
  font-size: 16px;
  line-height: 1.5;
  -webkit-font-smoothing: antialiased;
}

h1,
h2,
h3 {
  font-family: var(--font-display);
  font-weight: 500;
  margin: 0;
  color: var(--ink);
}

p {
  margin: 0;
}

button {
  font-family: var(--font-body);
  cursor: pointer;
}

button:focus-visible,
a:focus-visible,
input:focus-visible {
  outline: 2px solid var(--brass);
  outline-offset: 2px;
}

a {
  color: inherit;
}

@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
FILEEOF

echo 'Writing src/App.js'
cat > src/App.js << 'FILEEOF'
import React from "react";
import { Routes, Route } from "react-router-dom";
import LandingPage from "./components/LandingPage";
import ProductSelectionPage from "./pages/ProductSelectionPage";

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/plan" element={<ProductSelectionPage />} />
    </Routes>
  );
}
FILEEOF

echo 'Writing src/app/store.js'
cat > src/app/store.js << 'FILEEOF'
import { configureStore } from "@reduxjs/toolkit";
import roomsReducer from "../features/rooms/roomsSlice";
import addOnsReducer from "../features/addOns/addOnsSlice";
import mealsReducer from "../features/meals/mealsSlice";

export const store = configureStore({
  reducer: {
    rooms: roomsReducer,
    addOns: addOnsReducer,
    meals: mealsReducer,
  },
});
FILEEOF

echo 'Writing src/data/products.js'
cat > src/data/products.js << 'FILEEOF'
export const ROOMS = [
  { id: "auditorium", name: "Auditorium hall", capacity: 200, price: 5500 },
  { id: "conference", name: "Conference room", capacity: 15, price: 3500 },
  { id: "presentation", name: "Presentation room", capacity: 50, price: 700 },
  { id: "largeMeeting", name: "Large meeting room", capacity: 10, price: 900 },
  { id: "smallMeeting", name: "Small meeting room", capacity: 5, price: 1100 },
];

export const ADD_ONS = [
  { id: "speakers", name: "Speakers", price: 35 },
  { id: "microphones", name: "Microphones", price: 45 },
  { id: "whiteboards", name: "Whiteboards", price: 80 },
  { id: "projectors", name: "Projectors", price: 200 },
  { id: "signage", name: "Signage", price: 80 },
];

export const MEALS = [
  { id: "breakfast", name: "Breakfast", price: 50, unit: "per person" },
  { id: "lunch", name: "Lunch", price: 60, unit: "per person" },
  { id: "highTea", name: "High tea", price: 25, unit: "per person" },
  { id: "dinner", name: "Dinner", price: 70, unit: "per person" },
];
FILEEOF

echo 'Writing src/features/rooms/roomsSlice.js'
cat > src/features/rooms/roomsSlice.js << 'FILEEOF'
import { createSlice } from "@reduxjs/toolkit";
import { ROOMS } from "../../data/products";

const initialState = ROOMS.reduce((quantities, room) => {
  quantities[room.id] = 0;
  return quantities;
}, {});

const roomsSlice = createSlice({
  name: "rooms",
  initialState,
  reducers: {
    incrementRoom: (state, action) => {
      state[action.payload] += 1;
    },
    decrementRoom: (state, action) => {
      state[action.payload] = Math.max(0, state[action.payload] - 1);
    },
  },
});

export const { incrementRoom, decrementRoom } = roomsSlice.actions;
export default roomsSlice.reducer;

// Selectors
export const selectRoomQuantities = (state) => state.rooms;
export const selectRoomLineItems = (state) =>
  ROOMS.map((room) => ({
    ...room,
    quantity: state.rooms[room.id],
    subtotal: state.rooms[room.id] * room.price,
  })).filter((item) => item.quantity > 0);
export const selectRoomsTotal = (state) =>
  ROOMS.reduce((sum, room) => sum + state.rooms[room.id] * room.price, 0);
FILEEOF

echo 'Writing src/features/addOns/addOnsSlice.js'
cat > src/features/addOns/addOnsSlice.js << 'FILEEOF'
import { createSlice } from "@reduxjs/toolkit";
import { ADD_ONS } from "../../data/products";

const initialState = ADD_ONS.reduce((quantities, addOn) => {
  quantities[addOn.id] = 0;
  return quantities;
}, {});

const addOnsSlice = createSlice({
  name: "addOns",
  initialState,
  reducers: {
    incrementAddOn: (state, action) => {
      state[action.payload] += 1;
    },
    decrementAddOn: (state, action) => {
      state[action.payload] = Math.max(0, state[action.payload] - 1);
    },
  },
});

export const { incrementAddOn, decrementAddOn } = addOnsSlice.actions;
export default addOnsSlice.reducer;

// Selectors
export const selectAddOnQuantities = (state) => state.addOns;
export const selectAddOnLineItems = (state) =>
  ADD_ONS.map((addOn) => ({
    ...addOn,
    quantity: state.addOns[addOn.id],
    subtotal: state.addOns[addOn.id] * addOn.price,
  })).filter((item) => item.quantity > 0);
export const selectAddOnsTotal = (state) =>
  ADD_ONS.reduce((sum, addOn) => sum + state.addOns[addOn.id] * addOn.price, 0);
FILEEOF

echo 'Writing src/features/meals/mealsSlice.js'
cat > src/features/meals/mealsSlice.js << 'FILEEOF'
import { createSlice } from "@reduxjs/toolkit";
import { MEALS } from "../../data/products";

const initialState = MEALS.reduce((headcounts, meal) => {
  headcounts[meal.id] = 0;
  return headcounts;
}, {});

const mealsSlice = createSlice({
  name: "meals",
  initialState,
  reducers: {
    setMealCount: (state, action) => {
      const { id, count } = action.payload;
      const safeCount = Number.isFinite(count) && count > 0 ? Math.floor(count) : 0;
      state[id] = safeCount;
    },
  },
});

export const { setMealCount } = mealsSlice.actions;
export default mealsSlice.reducer;

// Selectors
export const selectMealCounts = (state) => state.meals;
export const selectMealLineItems = (state) =>
  MEALS.map((meal) => ({
    ...meal,
    quantity: state.meals[meal.id],
    subtotal: state.meals[meal.id] * meal.price,
  })).filter((item) => item.quantity > 0);
export const selectMealsTotal = (state) =>
  MEALS.reduce((sum, meal) => sum + state.meals[meal.id] * meal.price, 0);
FILEEOF

echo 'Writing src/utils/pricing.js'
cat > src/utils/pricing.js << 'FILEEOF'
export function formatCurrency(amount) {
  return amount.toLocaleString("en-US", {
    style: "currency",
    currency: "USD",
    maximumFractionDigits: 0,
  });
}
FILEEOF

echo 'Writing src/components/LandingPage.jsx'
cat > src/components/LandingPage.jsx << 'FILEEOF'
import React from "react";
import { Link } from "react-router-dom";
import "./LandingPage.css";

export default function LandingPage() {
  return (
    <main className="landing">
      <section className="landing__copy">
        <p className="landing__mark">Assemblage</p>
        <h1 className="landing__headline">
          Price out your conference before you book a single room.
        </h1>
        <p className="landing__body">
          Assemblage helps event organizers put a real number on a conference
          in minutes. Choose your rooms, add the audio-visual gear your
          sessions need, and set a headcount for each meal &mdash; we total the
          cost as you go, so you can walk into a budget conversation with
          confidence instead of a guess.
        </p>
        <Link to="/plan" className="landing__cta">
          Get started
        </Link>
      </section>
      <section className="landing__visual" aria-hidden="true">
        <div className="landing__seatmap">
          {Array.from({ length: 8 }).map((_, row) => (
            <div className="landing__seatrow" key={row}>
              {Array.from({ length: 12 }).map((__, seat) => (
                <span className="landing__seat" key={seat} />
              ))}
            </div>
          ))}
        </div>
        <p className="landing__visual-caption">Every seat, accounted for.</p>
      </section>
    </main>
  );
}
FILEEOF

echo 'Writing src/components/LandingPage.css'
cat > src/components/LandingPage.css << 'FILEEOF'
.landing {
  min-height: 100vh;
  display: grid;
  grid-template-columns: minmax(320px, 460px) 1fr;
}

.landing__copy {
  padding: var(--space-5) var(--space-4);
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: var(--space-3);
}

.landing__mark {
  font-family: var(--font-display);
  font-size: 1.1rem;
  letter-spacing: 0.02em;
  color: var(--brass-dark);
  margin: 0;
}

.landing__headline {
  font-size: clamp(2rem, 3.2vw, 2.75rem);
  line-height: 1.15;
  max-width: 20ch;
}

.landing__body {
  color: var(--slate);
  font-size: 1.05rem;
  line-height: 1.65;
  max-width: 46ch;
}

.landing__cta {
  align-self: flex-start;
  margin-top: var(--space-2);
  background: var(--ink);
  color: var(--paper);
  text-decoration: none;
  font-weight: 500;
  padding: 0.9rem 1.75rem;
  border: 1px solid var(--ink);
  transition: background 0.15s ease, color 0.15s ease;
}

.landing__cta:hover {
  background: var(--paper);
  color: var(--ink);
}

.landing__visual {
  background: var(--ink);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--space-3);
  padding: var(--space-4);
}

.landing__seatmap {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.landing__seatrow {
  display: flex;
  gap: 10px;
}

.landing__seat {
  width: 9px;
  height: 9px;
  background: var(--brass);
  opacity: 0.55;
  border-radius: 1px;
}

.landing__seatrow:nth-child(3) .landing__seat,
.landing__seatrow:nth-child(6) .landing__seat {
  opacity: 0.9;
}

.landing__visual-caption {
  font-family: var(--font-display);
  font-style: italic;
  color: var(--paper);
  opacity: 0.75;
  font-size: 0.95rem;
}

@media (max-width: 860px) {
  .landing {
    grid-template-columns: 1fr;
  }

  .landing__visual {
    padding: var(--space-4) var(--space-3);
  }

  .landing__seat {
    width: 6px;
    height: 6px;
    gap: 6px;
  }
}
FILEEOF

echo 'Writing src/components/Header.jsx'
cat > src/components/Header.jsx << 'FILEEOF'
import React from "react";
import { Link } from "react-router-dom";
import "./Header.css";

export default function Header({ onShowDetails, itemCount }) {
  return (
    <header className="ph">
      <Link to="/" className="ph__mark">
        Assemblage
      </Link>
      <nav className="ph__nav" aria-label="Page sections">
        <a href="#rooms">Rooms</a>
        <a href="#addons">Add-ons</a>
        <a href="#meals">Meals</a>
      </nav>
      <button type="button" className="ph__details" onClick={onShowDetails}>
        Show details
        {itemCount > 0 && <span className="ph__badge">{itemCount}</span>}
      </button>
    </header>
  );
}
FILEEOF

echo 'Writing src/components/Header.css'
cat > src/components/Header.css << 'FILEEOF'
.ph {
  position: sticky;
  top: 0;
  z-index: 20;
  display: flex;
  align-items: center;
  gap: var(--space-4);
  padding: var(--space-2) var(--space-4);
  background: var(--paper);
  border-bottom: 1px solid var(--line);
}

.ph__mark {
  font-family: var(--font-display);
  font-size: 1.1rem;
  text-decoration: none;
  color: var(--ink);
  margin-right: auto;
}

.ph__nav {
  display: flex;
  gap: var(--space-3);
}

.ph__nav a {
  text-decoration: none;
  color: var(--slate);
  font-size: 0.95rem;
  padding-bottom: 2px;
  border-bottom: 1px solid transparent;
}

.ph__nav a:hover {
  color: var(--ink);
  border-bottom-color: var(--brass);
}

.ph__details {
  position: relative;
  background: transparent;
  border: 1px solid var(--ink);
  color: var(--ink);
  padding: 0.55rem 1.1rem;
  font-size: 0.95rem;
  font-weight: 500;
}

.ph__details:hover {
  background: var(--ink);
  color: var(--paper);
}

.ph__badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 1.3rem;
  height: 1.3rem;
  margin-left: 0.5rem;
  background: var(--brass);
  color: var(--paper);
  font-size: 0.75rem;
  border-radius: 999px;
  padding: 0 0.35rem;
}

@media (max-width: 720px) {
  .ph {
    flex-wrap: wrap;
    gap: var(--space-2);
  }

  .ph__nav {
    order: 3;
    width: 100%;
    gap: var(--space-2);
  }
}
FILEEOF

echo 'Writing src/components/QuantityStepper.jsx'
cat > src/components/QuantityStepper.jsx << 'FILEEOF'
import React from "react";
import "./QuantityStepper.css";

export default function QuantityStepper({ label, quantity, onIncrement, onDecrement }) {
  return (
    <div className="stepper" role="group" aria-label={`${label} quantity`}>
      <button
        type="button"
        className="stepper__btn"
        onClick={onDecrement}
        disabled={quantity === 0}
        aria-label={`Remove one ${label}`}
      >
        &minus;
      </button>
      <span className="stepper__value">{quantity}</span>
      <button
        type="button"
        className="stepper__btn"
        onClick={onIncrement}
        aria-label={`Add one ${label}`}
      >
        +
      </button>
    </div>
  );
}
FILEEOF

echo 'Writing src/components/QuantityStepper.css'
cat > src/components/QuantityStepper.css << 'FILEEOF'
.stepper {
  display: inline-flex;
  align-items: center;
  border: 1px solid var(--line-strong);
}

.stepper__btn {
  width: 2.1rem;
  height: 2.1rem;
  background: var(--paper-raised);
  border: none;
  font-size: 1.1rem;
  color: var(--ink);
  line-height: 1;
}

.stepper__btn:first-child {
  border-right: 1px solid var(--line-strong);
}

.stepper__btn:last-child {
  border-left: 1px solid var(--line-strong);
}

.stepper__btn:hover:not(:disabled) {
  background: var(--ink);
  color: var(--paper);
}

.stepper__btn:disabled {
  color: var(--line-strong);
  cursor: not-allowed;
}

.stepper__value {
  min-width: 2.4rem;
  text-align: center;
  font-variant-numeric: tabular-nums;
  font-weight: 500;
}
FILEEOF

echo 'Writing src/components/RoomsSection.jsx'
cat > src/components/RoomsSection.jsx << 'FILEEOF'
import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { ROOMS } from "../data/products";
import { incrementRoom, decrementRoom } from "../features/rooms/roomsSlice";
import { formatCurrency } from "../utils/pricing";
import QuantityStepper from "./QuantityStepper";
import "./ProductSection.css";

export default function RoomsSection() {
  const quantities = useSelector((state) => state.rooms);
  const dispatch = useDispatch();

  return (
    <section id="rooms" className="psec">
      <h2 className="psec__title">Rooms</h2>
      <p className="psec__intro">
        Choose the spaces your sessions need. Capacity is per room, per day.
      </p>
      <ul className="psec__list">
        {ROOMS.map((room) => (
          <li className="psec__row" key={room.id}>
            <div className="psec__row-info">
              <p className="psec__row-name">{room.name}</p>
              <p className="psec__row-meta">
                Capacity {room.capacity} &middot; {formatCurrency(room.price)} each
              </p>
            </div>
            <QuantityStepper
              label={room.name}
              quantity={quantities[room.id]}
              onIncrement={() => dispatch(incrementRoom(room.id))}
              onDecrement={() => dispatch(decrementRoom(room.id))}
            />
          </li>
        ))}
      </ul>
    </section>
  );
}
FILEEOF

echo 'Writing src/components/AddOnsSection.jsx'
cat > src/components/AddOnsSection.jsx << 'FILEEOF'
import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { ADD_ONS } from "../data/products";
import { incrementAddOn, decrementAddOn } from "../features/addOns/addOnsSlice";
import { formatCurrency } from "../utils/pricing";
import QuantityStepper from "./QuantityStepper";
import "./ProductSection.css";

export default function AddOnsSection() {
  const quantities = useSelector((state) => state.addOns);
  const dispatch = useDispatch();

  return (
    <section id="addons" className="psec psec--alt">
      <h2 className="psec__title">Add-ons</h2>
      <p className="psec__intro">
        Audio-visual equipment for presentations, priced per unit for the
        event.
      </p>
      <ul className="psec__list">
        {ADD_ONS.map((addOn) => (
          <li className="psec__row" key={addOn.id}>
            <div className="psec__row-info">
              <p className="psec__row-name">{addOn.name}</p>
              <p className="psec__row-meta">{formatCurrency(addOn.price)} each</p>
            </div>
            <QuantityStepper
              label={addOn.name}
              quantity={quantities[addOn.id]}
              onIncrement={() => dispatch(incrementAddOn(addOn.id))}
              onDecrement={() => dispatch(decrementAddOn(addOn.id))}
            />
          </li>
        ))}
      </ul>
    </section>
  );
}
FILEEOF

echo 'Writing src/components/MealsSection.jsx'
cat > src/components/MealsSection.jsx << 'FILEEOF'
import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { MEALS } from "../data/products";
import { setMealCount } from "../features/meals/mealsSlice";
import { formatCurrency } from "../utils/pricing";
import "./ProductSection.css";

export default function MealsSection() {
  const counts = useSelector((state) => state.meals);
  const dispatch = useDispatch();

  const handleChange = (id, rawValue) => {
    const parsed = parseInt(rawValue, 10);
    dispatch(setMealCount({ id, count: Number.isNaN(parsed) ? 0 : parsed }));
  };

  return (
    <section id="meals" className="psec">
      <h2 className="psec__title">Meals</h2>
      <p className="psec__intro">
        Enter how many people to cater for each meal service.
      </p>
      <ul className="psec__list">
        {MEALS.map((meal) => (
          <li className="psec__row" key={meal.id}>
            <div className="psec__row-info">
              <p className="psec__row-name">{meal.name}</p>
              <p className="psec__row-meta">
                {formatCurrency(meal.price)} {meal.unit}
              </p>
            </div>
            <label className="psec__count">
              <span className="psec__count-label">Guests</span>
              <input
                type="number"
                min="0"
                inputMode="numeric"
                value={counts[meal.id] === 0 ? "" : counts[meal.id]}
                placeholder="0"
                onChange={(event) => handleChange(meal.id, event.target.value)}
              />
            </label>
          </li>
        ))}
      </ul>
    </section>
  );
}
FILEEOF

echo 'Writing src/components/ProductSection.css'
cat > src/components/ProductSection.css << 'FILEEOF'
.psec {
  max-width: 760px;
  margin: 0 auto;
  padding: var(--space-4);
  scroll-margin-top: 4.5rem;
}

.psec--alt {
  background: var(--paper-raised);
  max-width: none;
  border-top: 1px solid var(--line);
  border-bottom: 1px solid var(--line);
}

.psec--alt > * {
  max-width: 760px;
  margin-left: auto;
  margin-right: auto;
}

.psec__title {
  font-size: 1.6rem;
}

.psec__intro {
  color: var(--slate);
  margin-top: 0.4rem;
  max-width: 55ch;
}

.psec__list {
  list-style: none;
  margin: var(--space-3) 0 0;
  padding: 0;
  border-top: 1px solid var(--line);
}

.psec__row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-2);
  padding: var(--space-2) 0;
  border-bottom: 1px solid var(--line);
}

.psec__row-name {
  font-weight: 500;
}

.psec__row-meta {
  color: var(--slate);
  font-size: 0.9rem;
  margin-top: 0.2rem;
}

.psec__count {
  display: flex;
  align-items: center;
  gap: 0.6rem;
}

.psec__count-label {
  font-size: 0.85rem;
  color: var(--slate);
}

.psec__count input {
  width: 4rem;
  padding: 0.5rem;
  border: 1px solid var(--line-strong);
  background: var(--paper-raised);
  font-size: 1rem;
  text-align: center;
}
FILEEOF

echo 'Writing src/components/SummaryModal.jsx'
cat > src/components/SummaryModal.jsx << 'FILEEOF'
import React, { useEffect, useRef } from "react";
import { useSelector } from "react-redux";
import { selectRoomLineItems, selectRoomsTotal } from "../features/rooms/roomsSlice";
import { selectAddOnLineItems, selectAddOnsTotal } from "../features/addOns/addOnsSlice";
import { selectMealLineItems, selectMealsTotal } from "../features/meals/mealsSlice";
import { formatCurrency } from "../utils/pricing";
import "./SummaryModal.css";

export default function SummaryModal({ onClose }) {
  const dialogRef = useRef(null);

  const roomItems = useSelector(selectRoomLineItems);
  const addOnItems = useSelector(selectAddOnLineItems);
  const mealItems = useSelector(selectMealLineItems);

  const roomsTotal = useSelector(selectRoomsTotal);
  const addOnsTotal = useSelector(selectAddOnsTotal);
  const mealsTotal = useSelector(selectMealsTotal);
  const grandTotal = roomsTotal + addOnsTotal + mealsTotal;

  const lineItems = [...roomItems, ...addOnItems, ...mealItems];

  useEffect(() => {
    const handleKeyDown = (event) => {
      if (event.key === "Escape") onClose();
    };
    document.addEventListener("keydown", handleKeyDown);
    dialogRef.current?.focus();
    return () => document.removeEventListener("keydown", handleKeyDown);
  }, [onClose]);

  return (
    <div className="modal__overlay" onClick={onClose}>
      <div
        className="modal"
        role="dialog"
        aria-modal="true"
        aria-labelledby="summary-title"
        ref={dialogRef}
        tabIndex={-1}
        onClick={(event) => event.stopPropagation()}
      >
        <div className="modal__header">
          <h2 id="summary-title">Your selections</h2>
          <button type="button" className="modal__close" onClick={onClose} aria-label="Close">
            &times;
          </button>
        </div>

        {lineItems.length === 0 ? (
          <p className="modal__empty">
            Nothing selected yet. Add rooms, add-ons, or meals to see a running
            total here.
          </p>
        ) : (
          <table className="modal__table">
            <thead>
              <tr>
                <th scope="col">Item</th>
                <th scope="col">Unit cost</th>
                <th scope="col">Qty</th>
                <th scope="col">Subtotal</th>
              </tr>
            </thead>
            <tbody>
              {lineItems.map((item) => (
                <tr key={item.id}>
                  <td>{item.name}</td>
                  <td>{formatCurrency(item.price)}</td>
                  <td>{item.quantity}</td>
                  <td>{formatCurrency(item.subtotal)}</td>
                </tr>
              ))}
            </tbody>
            <tfoot>
              <tr>
                <th scope="row" colSpan={3}>
                  Total
                </th>
                <td>{formatCurrency(grandTotal)}</td>
              </tr>
            </tfoot>
          </table>
        )}
      </div>
    </div>
  );
}
FILEEOF

echo 'Writing src/components/SummaryModal.css'
cat > src/components/SummaryModal.css << 'FILEEOF'
.modal__overlay {
  position: fixed;
  inset: 0;
  background: rgba(27, 36, 48, 0.55);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-3);
  z-index: 50;
}

.modal {
  background: var(--paper-raised);
  width: min(560px, 100%);
  max-height: 85vh;
  overflow-y: auto;
  border: 1px solid var(--line-strong);
  padding: var(--space-3) var(--space-4) var(--space-4);
}

.modal__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--line);
  padding-bottom: var(--space-2);
  margin-bottom: var(--space-2);
}

.modal__header h2 {
  font-size: 1.4rem;
}

.modal__close {
  background: none;
  border: none;
  font-size: 1.6rem;
  line-height: 1;
  color: var(--slate);
  padding: 0;
}

.modal__close:hover {
  color: var(--ink);
}

.modal__empty {
  color: var(--slate);
  padding: var(--space-2) 0;
}

.modal__table {
  width: 100%;
  border-collapse: collapse;
}

.modal__table th,
.modal__table td {
  text-align: left;
  padding: 0.6rem 0.4rem;
  border-bottom: 1px solid var(--line);
  font-size: 0.95rem;
}

.modal__table thead th {
  color: var(--slate);
  font-weight: 500;
  font-size: 0.85rem;
}

.modal__table th:not(:first-child),
.modal__table td:not(:first-child) {
  text-align: right;
}

.modal__table tfoot th,
.modal__table tfoot td {
  border-bottom: none;
  border-top: 2px solid var(--ink);
  font-family: var(--font-display);
  font-size: 1.1rem;
  padding-top: var(--space-2);
}
FILEEOF

echo 'Writing src/pages/ProductSelectionPage.jsx'
cat > src/pages/ProductSelectionPage.jsx << 'FILEEOF'
import React, { useState } from "react";
import { useSelector } from "react-redux";
import Header from "../components/Header";
import RoomsSection from "../components/RoomsSection";
import AddOnsSection from "../components/AddOnsSection";
import MealsSection from "../components/MealsSection";
import SummaryModal from "../components/SummaryModal";
import "./ProductSelectionPage.css";

export default function ProductSelectionPage() {
  const [isSummaryOpen, setSummaryOpen] = useState(false);

  const itemCount = useSelector((state) => {
    const rooms = Object.values(state.rooms).reduce((a, b) => a + b, 0);
    const addOns = Object.values(state.addOns).reduce((a, b) => a + b, 0);
    const meals = Object.values(state.meals).filter((count) => count > 0).length;
    return rooms + addOns + meals;
  });

  return (
    <div className="psp">
      <Header onShowDetails={() => setSummaryOpen(true)} itemCount={itemCount} />
      <RoomsSection />
      <AddOnsSection />
      <MealsSection />
      {isSummaryOpen && <SummaryModal onClose={() => setSummaryOpen(false)} />}
    </div>
  );
}
FILEEOF

echo 'Writing src/pages/ProductSelectionPage.css'
cat > src/pages/ProductSelectionPage.css << 'FILEEOF'
.psp {
  min-height: 100vh;
}
FILEEOF

echo 'Done. Now switching BrowserRouter to HashRouter...'
sed -i 's/BrowserRouter/HashRouter/g' src/index.js

echo 'Structure fixed. Running build to verify...'
npm run build

echo 'If build succeeded, now run: git add . && git commit -m "fix project structure" && git push'
echo 'Then run: npm run deploy'


