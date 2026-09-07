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
