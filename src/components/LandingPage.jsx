import React from "react";
import { Link } from "react-router-dom";
import "./LandingPage.css";

export default function LandingPage() {
  return (
    <main className="landing">
      <section className="landing__copy">
        <p className="landing__mark">Assemblage</p>
        <h1 className="landing__headline">
          Price out your conference before you book a single room.
        </h1>
        <p className="landing__body">
          Assemblage helps event organizers put a real number on a conference
          in minutes. Choose your rooms, add the audio-visual gear your
          sessions need, and set a headcount for each meal &mdash; we total the
          cost as you go, so you can walk into a budget conversation with
          confidence instead of a guess.
        </p>
        <Link to="/plan" className="landing__cta">
          Get started
        </Link>
      </section>
      <section className="landing__visual" aria-hidden="true">
        <div className="landing__seatmap">
          {Array.from({ length: 8 }).map((_, row) => (
            <div className="landing__seatrow" key={row}>
              {Array.from({ length: 12 }).map((__, seat) => (
                <span className="landing__seat" key={seat} />
              ))}
            </div>
          ))}
        </div>
        <p className="landing__visual-caption">Every seat, accounted for.</p>
      </section>
    </main>
  );
}
