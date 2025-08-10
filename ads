{
  "name": "nemo-landing",
  "private": true,
  "version": "0.1.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.2.3",
    "react": "18.2.0",
    "react-dom": "18.2.0"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.17",
    "postcss": "^8.4.35",
    "tailwindcss": "^3.4.4",
    "eslint": "^8.57.0",
    "eslint-config-next": "14.2.3"
  }
}
export default { reactStrictMode: true };
module.exports = { plugins: { tailwindcss: {}, autoprefixer: {} } };
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,ts,jsx,tsx}", "./components/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: [],
};
{ "compilerOptions": { "baseUrl": ".", "paths": { "@/*": ["./*"] } } }
@tailwind base;
@tailwind components;
@tailwind utilities;

:root { color-scheme: light; }
html, body { height: 100%; }
export const metadata = {
  title: "Nemo Group · Agosto → Settembre",
  description: "Landing interattiva con quiz per franchisor · Nemo Group",
};
export default function RootLayout({ children }) {
  return (
    <html lang="it">
      <body className="min-h-screen">{children}</body>
    </html>
  );
}
'use client'
import React, { useMemo, useState, useEffect } from "react";

const CALENDLY_LINK = "https://calendly.com/gianluca-ranno-nemofranchising/nemo-group-france";
const FORM_ENDPOINT = "https://example.com/api/lead"; // TODO: metti il tuo Formspree/Zapier
const LOGO_URL = "/public/nemo-logo.png";  // se non vedi il logo, prova "/nemo-logo.png"
const PROFILE_IMG = "/public/gianluca.jpg"; // idem sopra
const PROFILE_LINK = "https://www.linkedin.com/in/gianlucaranno/";
const NAME = "Gian Luca Ranno";

const CLIENT_LOGOS = [
  { src: "/public/logos/soloaffitti.png", alt: "SoloAffitti" },
  { src: "/public/logos/ovs.png", alt: "OVS" },
  { src: "/public/logos/mbe.png", alt: "Mail Boxes Etc." },
  { src: "/public/logos/goldenpoint.png", alt: "Goldenpoint" },
  { src: "/public/logos/kidsandus.png", alt: "Kids&Us" },
  { src: "/public/logos/naturhouse.png", alt: "Naturhouse" },
  { src: "/public/logos/kumon.png", alt: "Kumon" },
];

export default function Page() {
  const [step, setStep] = useState(0);
  const [form, setForm] = useState({ company: "", name: "", role: "", email: "", phone: "", notes: "" });
  const [answers, setAnswers] = useState({ leadTarget: "", budget: "", geo: "", time: "", funnel: "", team: "" });

  const questions = [
    { key: "leadTarget", label: "Quante anagrafiche qualificate vuoi ogni mese?", options: [ { v: "<50", label: "Fino a 50/mese" }, { v: "50-150", label: "50–150/mese" }, { v: ">150", label: ">150/mese" } ] },
    { key: "budget", label: "Qual è il budget mensile stimato per la lead generation?", options: [ { v: "<2k", label: "< 2.000€" }, { v: "2-5k", label: "2.000–5.000€" }, { v: ">5k", label: "> 5.000€" } ] },
    { key: "geo", label: "Dove vuoi crescere?", options: [ { v: "italy", label: "Italia" }, { v: "eu", label: "Europa" }, { v: "global", label: "Globale" } ] },
    { key: "time", label: "Entro quando vuoi vedere i primi risultati?", options: [ { v: "now", label: "Subito (entro 2–3 settimane)" }, { v: "quarter", label: "Entro un trimestre" }, { v: "later", label: "Nel medio periodo" } ] },
    { key: "funnel", label: "Com’è oggi il tuo funnel di affiliazione?", options: [ { v: "nocontent", label: "Pochi contenuti, nessuna landing dedicata" }, { v: "some", label: "Qualche contenuto e una landing base" }, { v: "mature", label: "Funnel maturo con nurturing e KPI" } ] },
    { key: "team", label: "Hai un team interno per gestire le anagrafiche?", options: [ { v: "solo", label: "No, serve supporto completo" }, { v: "small", label: "Sì, team snello (1–2 persone)" }, { v: "full", label: "Sì, team strutturato" } ] },
  ];

  const score = useMemo(() => {
    let s = 0;
    if (answers.leadTarget === ">150") s += 3; else if (answers.leadTarget === "50-150") s += 2; else if (answers.leadTarget) s += 1;
    if (answers.budget === ">5k") s += 3; else if (answers.budget === "2-5k") s += 2; else if (answers.budget) s += 1;
    if (answers.funnel === "mature") s += 3; else if (answers.funnel === "some") s += 2; else if (answers.funnel) s += 1;
    if (answers.team === "full") s += 3; else if (answers.team === "small") s += 2; else if (answers.team) s += 1;
    return s;
  }, [answers]);

  const tier = useMemo(() => {
    if (score >= 10) return { name: "Scale Fast", desc: "Settembre alla grande: multicanale, multi-paese, ottimizzazione continua." };
    if (score >= 7) return { name: "Grow Steady", desc: "Rotta chiara per l’autunno: contenuti, landing e lead qualificate costanti." };
    return { name: "Kickstart", desc: "Agosto smart: mettiamo a terra il funnel e partiamo con le prime lead." };
  }, [score]);

  const percent = Math.round((step / questions.length) * 100);
  function pick(key, v) { setAnswers((old) => ({ ...old, [key]: v })); setStep((s) => Math.min(s + 1, questions.length)); }

  async function submitLead(e) {
    e.preventDefault();
    try {
      await fetch(FORM_ENDPOINT, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ ...form, ...answers, source: "nemo-landing-quiz" }) });
      window.location.href = CALENDLY_LINK;
    } catch (err) { window.location.href = CALENDLY_LINK; }
  }

  const [logos, setLogos] = useState(CLIENT_LOGOS.concat(CLIENT_LOGOS));
  useEffect(() => { setLogos(CLIENT_LOGOS.concat(CLIENT_LOGOS)); }, []);

  return (
    <div className="min-h-screen bg-gradient-to-b from-sky-50 via-emerald-50 to-teal-50 text-slate-900">
      {/* Header */}
      <header className="sticky top-0 z-20 backdrop-blur bg-white/70 border-b border-slate-200">
        <div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between">
          <img src={LOGO_URL} alt="Nemo Group" className="h-10 w-auto" />
          <div className="flex items-center gap-3">
            <a href={PROFILE_LINK} target="_blank" className="hidden sm:flex items-center gap-2 px-3 py-1 rounded-full border border-slate-200 hover:border-teal-300">
              <img src={PROFILE_IMG} alt={NAME} className="w-6 h-6 rounded-full object-cover"/>
              <span className="text-sm font-medium">{NAME}</span>
            </a>
            <a href={CALENDLY_LINK} target="_blank" className="px-4 py-2 rounded-xl bg-teal-500 hover:bg-teal-400 text-white font-semibold shadow">Prenota una call</a>
          </div>
        </div>
      </header>

      {/* Hero */}
      <section className="max-w-6xl mx-auto px-4 pt-10 pb-6">
        <div className="grid md:grid-cols-2 gap-8 items-center">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-slate-200 bg-white/60 text-xs uppercase tracking-widest text-teal-700">Agosto non si butta · Si prepara Settembre</div>
            <h1 className="mt-4 text-4xl md:text-5xl font-extrabold leading-tight">Trasforma Agosto in <span className="text-teal-600">vantaggio competitivo</span>.</h1>
            <p className="mt-4 text-slate-700 text-lg">Mentre gli altri sono fermi, tu prepari il terreno: contenuti che presidiano Google, landing che convertono e anagrafiche che <em>vogliono</em> sentirti a settembre.</p>
            <div className="mt-6 flex flex-wrap items-center gap-3">
              <a href="#quiz" className="px-5 py-3 rounded-2xl bg-teal-500 hover:bg-teal-400 text-white font-semibold shadow">Fai il check in 60 secondi</a>
              <a href={CALENDLY_LINK} target="_blank" className="px-5 py-3 rounded-2xl border border-slate-300 hover:border-teal-400">Parla con {NAME}</a>
              <a href={PROFILE_LINK} target="_blank" className="flex items-center gap-2 text-slate-700 hover:text-teal-700">
                <img src={PROFILE_IMG} alt={NAME} className="w-8 h-8 rounded-full object-cover"/>
                <span className="underline underline-offset-2">Profilo LinkedIn</span>
              </a>
            </div>
            <div className="mt-6 text-sm text-slate-600">
              <span className="mr-3">• 12,5M+ utenti raggiunti</span>
              <span className="mr-3">• 95% rinnovi</span>
              <span>• 1000+ anagrafiche/mese</span>
            </div>
          </div>
          <div className="relative">
            <div className="absolute -inset-6 bg-teal-300/20 blur-2xl rounded-3xl"/>
            <div className="relative rounded-3xl border border-slate-200 p-6 bg-white/70 shadow-2xl">
              <div className="text-sm text-slate-600">Case Study</div>
              <div className="mt-1 text-2xl font-bold">SoloAffitti</div>
              <ul className="mt-4 space-y-2 text-slate-700">
                <li>• 870 anagrafiche profilate</li>
                <li>• 1,4M visualizzazioni brand</li>
                <li>• 8 contenuti editoriali · 3 landing</li>
                <li>• <span className="font-semibold">10 nuove aperture</span> generate dalla campagna</li>
              </ul>
              <div className="mt-5 text-xs text-slate-500">Campagna organica su network editoriale (2021–2023).</div>
            </div>
          </div>
        </div>
      </section>

      {/* Client logo carousel */}
      <section className="max-w-6xl mx-auto px-4 pb-2">
        <div className="rounded-2xl border border-slate-200 bg-white/60 overflow-hidden">
          <div className="flex items-center justify-between px-4 py-3">
            <div className="text-sm text-teal-700 font-semibold">Alcuni dei brand che ci hanno scelto</div>
            <div className="text-xs text-slate-500">(se scorrono troppo veloci, passa il mouse per fermare)</div>
          </div>
          <div className="relative">
            <div className="group overflow-hidden">
              <div className="flex gap-10 items-center animate-[marquee_30s_linear_infinite] group-hover:[animation-play-state:paused]">
                {logos.map((l, i) => (
                  <img key={i} src={l.src} alt={l.alt} className="h-10 w-auto opacity-80 hover:opacity-100 transition" />
                ))}
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Proof bar */}
      <section className="max-w-6xl mx-auto px-4 pb-2">
        <div className="grid sm:grid-cols-3 gap-3">
          {[{ k: "reach", t: "Copertura", v: "12,5M+", d: "utenti sui siti partner" }, { k: "renew", t: "Rinnovi", v: "95%", d: "tasso medio clienti" }, { k: "leads", t: "Volume", v: "1000+", d: "anagrafiche/mese" }].map((x) => (
            <div key={x.k} className="rounded-2xl border border-slate-200 p-4 bg-white/70">
              <div className="text-sm text-slate-600">{x.t}</div>
              <div className="text-3xl font-extrabold mt-1 text-teal-700">{x.v}</div>
              <div className="text-sm text-slate-600">{x.d}</div>
            </div>
          ))}
        </div>
      </section>

      {/* Quiz */}
      <section id="quiz" className="max-w-6xl mx-auto px-4 pb-4">
        <div className="rounded-3xl border border-slate-200 p-6 bg-white/70">
          <div className="flex items-center justify-between gap-4">
            <h3 className="text-xl font-bold">Mini-diagnosi: cosa puoi sbloccare entro Settembre?</h3>
            <div className="flex-1 h-2 ml-6 bg-slate-200 rounded-full overflow-hidden">
              <div className="h-full bg-teal-500" style={{ width: `${percent}%` }} />
            </div>
            <div className="ml-3 text-sm text-slate-700 w-16 text-right">{percent}%</div>
          </div>

          {step < questions.length ? (
            <div className="mt-6">
              <div className="text-lg font-semibold">{questions[step].label}</div>
              <div className="mt-4 grid sm:grid-cols-3 gap-3">
                {questions[step].options.map((o) => (
                  <button key={o.v} onClick={() => pick(questions[step].key, o.v)} className="p-4 rounded-2xl border border-slate-200 hover:border-teal-400 bg-white/60 text-left">{o.label}</button>
                ))}
              </div>
              {step > 0 && (<button onClick={() => setStep((s) => Math.max(0, s - 1))} className="mt-4 text-sm underline underline-offset-2">Indietro</button>)}
            </div>
          ) : (
            <div className="mt-6 grid md:grid-cols-2 gap-6">
              <div>
                <div className="text-sm text-teal-700 font-semibold">Suggerimento</div>
                <div className="text-2xl font-bold">{tier.name}</div>
                <p className="mt-2 text-slate-700">{tier.desc}</p>
                <ul className="mt-4 space-y-2 text-sm text-slate-700 list-disc pl-5">
                  {tier.name === "Kickstart" && (<>
                    <li>Set up funnel di affiliazione e landing ottimizzata</li>
                    <li>Contenuti editoriali base su network</li>
                    <li>Prime 50–100 anagrafiche mirate</li>
                  </>)}
                  {tier.name === "Grow Steady" && (<>
                    <li>Editorial plan + 2–3 landing tematiche</li>
                    <li>Ottimizzazione continua con check ogni 30 lead</li>
                    <li>100–300 anagrafiche/mese</li>
                  </>)}
                  {tier.name === "Scale Fast" && (<>
                    <li>Copertura multi-paese + multicanale</li>
                    <li>Segmentazione avanzata e nurturing</li>
                    <li>300+ anagrafiche/mese</li>
                  </>)}
                </ul>
              </div>

              <form onSubmit={submitLead} className="rounded-2xl border border-slate-200 p-5 bg-white/70">
                <div className="text-lg font-semibold">Ricevi una stima e fissa la call</div>
                <p className="text-sm text-slate-600">Compila i dati: ti inviamo un recap del piano suggerito e il link al calendario.</p>
                <div className="mt-4 grid grid-cols-1 gap-3">
                  <input required placeholder="Azienda" className="px-4 py-3 rounded-xl bg-white border border-slate-200" value={form.company} onChange={(e)=>setForm({...form, company:e.target.value})}/>
                  <div className="grid sm:grid-cols-2 gap-3">
                    <input required placeholder="Nome e cognome" className="px-4 py-3 rounded-xl bg-white border border-slate-200" value={form.name} onChange={(e)=>setForm({...form, name:e.target.value})}/>
                    <input placeholder="Ruolo" className="px-4 py-3 rounded-xl bg-white border border-slate-200" value={form.role} onChange={(e)=>setForm({...form, role:e.target.value})}/>
                  </div>
                  <div className="grid sm:grid-cols-2 gap-3">
                    <input required type="email" placeholder="Email" className="px-4 py-3 rounded-xl bg-white border border-slate-200" value={form.email} onChange={(e)=>setForm({...form, email:e.target.value})}/>
                    <input placeholder="Telefono" className="px-4 py-3 rounded-xl bg-white border border-slate-200" value={form.phone} onChange={(e)=>setForm({...form, phone:e.target.value})}/>
                  </div>
                  <textarea rows={3} placeholder="Note (opzionale)" className="px-4 py-3 rounded-xl bg-white border border-slate-200" value={form.notes} onChange={(e)=>setForm({...form, notes:e.target.value})}></textarea>
                  <button className="mt-2 px-5 py-3 rounded-2xl bg-teal-500 hover:bg-teal-400 text-white font-semibold shadow">Invia e vai al calendario →</button>
                </div>
                <div className="mt-3 text-xs text-slate-500">Con l’invio autorizzi il trattamento dei dati per finalità di contatto commerciale. Nessuno spam, promesso.</div>
              </form>
            </div>
          )}
        </div>
      </section>

      {/* CTA Footer */}
      <footer className="border-t border-slate-200">
        <div className="max-w-6xl mx-auto px-4 py-8 grid md:grid-cols-3 gap-6 items-center">
          <div className="md:col-span-2">
            <div className="text-2xl font-bold">Chiudiamo Agosto con le idee chiare?</div>
            <p className="text-slate-700">Prenota 20 minuti con {NAME}: obiettivi, tempi e priorità. Se non è fit, te lo diciamo subito.</p>
          </div>
          <div className="flex md:justify-end">
            <a href={CALENDLY_LINK} target="_blank" className="px-6 py-3 rounded-2xl bg-teal-500 hover:bg-teal-400 text-white font-semibold shadow">Prenota ora</a>
          </div>
        </div>
        <div className="text-center text-xs text-slate-500 pb-6">© {new Date().getFullYear()} Nemo Group</div>
      </footer>

      <style>{`@keyframes marquee{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}`}</style>
    </div>
  );
}
