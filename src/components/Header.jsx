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
