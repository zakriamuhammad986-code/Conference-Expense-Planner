import React from "react";
import { Routes, Route } from "react-router-dom";
import LandingPage from "./components/LandingPage";
import ProductSelectionPage from "./pages/ProductSelectionPage";

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/plan" element={<ProductSelectionPage />} />
    </Routes>
  );
}
