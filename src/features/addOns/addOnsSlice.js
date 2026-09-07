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
