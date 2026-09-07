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
