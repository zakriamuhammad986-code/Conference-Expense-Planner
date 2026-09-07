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
