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
