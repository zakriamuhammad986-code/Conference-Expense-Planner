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
