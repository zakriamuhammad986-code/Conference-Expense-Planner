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
