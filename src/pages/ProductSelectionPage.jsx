import React, { useState } from "react";
import { useSelector } from "react-redux";
import Header from "../components/Header";
import RoomsSection from "../components/RoomsSection";
import AddOnsSection from "../components/AddOnsSection";
import MealsSection from "../components/MealsSection";
import SummaryModal from "../components/SummaryModal";
import "./ProductSelectionPage.css";

export default function ProductSelectionPage() {
  const [isSummaryOpen, setSummaryOpen] = useState(false);

  const itemCount = useSelector((state) => {
    const rooms = Object.values(state.rooms).reduce((a, b) => a + b, 0);
    const addOns = Object.values(state.addOns).reduce((a, b) => a + b, 0);
    const meals = Object.values(state.meals).filter((count) => count > 0).length;
    return rooms + addOns + meals;
  });

  return (
    <div className="psp">
      <Header onShowDetails={() => setSummaryOpen(true)} itemCount={itemCount} />
      <RoomsSection />
      <AddOnsSection />
      <MealsSection />
      {isSummaryOpen && <SummaryModal onClose={() => setSummaryOpen(false)} />}
    </div>
  );
}
