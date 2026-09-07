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
