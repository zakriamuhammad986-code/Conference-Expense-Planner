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
