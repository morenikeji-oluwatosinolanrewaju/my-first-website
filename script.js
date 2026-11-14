const API_BASE = "https://api.dictionaryapi.dev/api/v2/entries/en/";
const $ = (selector) => document.querySelector(selector);
const searchForm = $("#searchForm");
const wordInput = $("#wordInput");
const welcomeCard = $("#welcomeCard");
const loadingState = $("#loadingState");
const errorState = $("#errorState");
const wordResult = $("#wordResult");
const listPanel = $("#listPanel");
const wordList = $("#wordList");
const listTitle = $("#listTitle");

let currentEntry = null;
let listMode = "history";
let historyWords = readStore("lexicon-history");
let savedWords = readStore("lexicon-saved");

function readStore(key) {
  try {
    const value = JSON.parse(localStorage.getItem(key) || "[]");
    return Array.isArray(value) ? value : [];
  } catch {
    return [];
  }
}

function writeStore(key, value) {
  try { localStorage.setItem(key, JSON.stringify(value)); } catch (error) {
    console.warn("Could not save local data:", error);
  }
}

function cleanText(value) {
  return String(value ?? "").replace(/[&<>"']/g, char => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"
  })[char]);
}

function showState(state) {
  welcomeCard.classList.toggle("hidden", state !== "welcome");
  loadingState.classList.toggle("hidden", state !== "loading");
  errorState.classList.toggle("hidden", state !== "error");
  wordResult.classList.toggle("hidden", state !== "result");
}

function rememberWord(word) {
  const normalized = word.toLowerCase();
  historyWords = [normalized, ...historyWords.filter(item => item !== normalized)].slice(0, 30);
  writeStore("lexicon-history", historyWords);
}

async function searchWord(rawWord) {
  const word = rawWord.trim().toLowerCase();
  if (!word) return;
  wordInput.value = word;
  listPanel.classList.add("hidden");
  showState("loading");

  try {
    const response = await fetch(API_BASE + encodeURIComponent(word));
    if (!response.ok) {
      if (response.status === 404) throw new Error("We couldn't find “" + word + "”. Check the spelling or try another word.");
      throw new Error("The dictionary service is temporarily unavailable. Please try again.");
    }
    const data = await response.json();
    if (!Array.isArray(data) || !data.length) throw new Error("No definition was returned for this word.");
    currentEntry = data[0];
    rememberWord(currentEntry.word || word);
    renderEntry(data);
    showState("result");
  } catch (error) {
    errorState.textContent = error.message || "Something went wrong. Please check your internet connection and try again.";
    showState("error");
  }
}

function renderEntry(entries) {
  const entry = entries[0];
  const word = entry.word || "Unknown word";
  const phonetic = entry.phonetic || (entry.phonetics || []).find(item => item.text)?.text || "Pronunciation not provided";
  const audio = (entry.phonetics || []).find(item => item.audio)?.audio;
  const isSaved = savedWords.includes(word.toLowerCase());

  const parts = (entry.meanings || []).map(meaning => {
    const definitions = (meaning.definitions || []).slice(0, 8).map((definition, index) => `
      <div class="definition">
        <span class="definition-number">${index + 1}.</span>
        <div><p>${cleanText(definition.definition)}</p>
        ${definition.example ? `<div class="example">“${cleanText(definition.example)}”</div>` : ""}</div>
      </div>`).join("");
    const synonyms = [...new Set([...(meaning.synonyms || []), ...(meaning.definitions || []).flatMap(item => item.synonyms || [])])].slice(0, 12);
    const antonyms = [...new Set([...(meaning.antonyms || []), ...(meaning.definitions || []).flatMap(item => item.antonyms || [])])].slice(0, 12);
    return `
      <section class="part-block">
        <h3 class="part-title">${cleanText(meaning.partOfSpeech || "Meaning")}</h3>
        ${definitions || '<p class="phonetic">No definition supplied for this category.</p>'}
        ${synonyms.length ? `<h4 class="word-label">SYNONYMS</h4><div class="tag-list">${synonyms.map(item => `<span class="word-tag">${cleanText(item)}</span>`).join("")}</div>` : ""}
        ${antonyms.length ? `<h4 class="word-label" style="margin-top:16px">ANTONYMS</h4><div class="tag-list">${antonyms.map(item => `<span class="word-tag">${cleanText(item)}</span>`).join("")}</div>` : ""}
      </section>`;
  }).join("");

  wordResult.innerHTML = `
    <div class="word-topline">
      <div><div class="word-label">DICTIONARY ENTRY</div><h2 class="word-title">${cleanText(word)}</h2><div class="phonetic">${cleanText(phonetic)}</div></div>
      <div class="word-actions">
        ${audio ? '<button class="round-action" id="audioButton" aria-label="Play pronunciation" title="Play pronunciation">▶</button>' : ""}
        <button class="round-action ${isSaved ? "active" : ""}" id="saveButton" aria-label="Save word" title="Save word">${isSaved ? "★" : "☆"}</button>
      </div>
    </div>
    ${parts || '<p class="phonetic">No definitions are available for this entry.</p>'}
    ${entry.origin ? `<section class="part-block"><h3 class="part-title">Word origin</h3><p class="phonetic">${cleanText(entry.origin)}</p></section>` : ""}
    <p class="phonetic" style="font-size:10px;margin-top:24px">English dictionary data provided by Free Dictionary API.</p>`;

  const audioButton = $("#audioButton");
  if (audioButton && audio) audioButton.addEventListener("click", () => {
    const player = new Audio(audio);
    player.play().catch(() => { audioButton.textContent = "Unavailable"; });
  });
  $("#saveButton").addEventListener("click", toggleSaved);
}

function toggleSaved() {
  if (!currentEntry?.word) return;
  const word = currentEntry.word.toLowerCase();
  savedWords = savedWords.includes(word) ? savedWords.filter(item => item !== word) : [word, ...savedWords];
  writeStore("lexicon-saved", savedWords);
  const button = $("#saveButton");
  if (button) {
    const active = savedWords.includes(word);
    button.classList.toggle("active", active);
    button.textContent = active ? "★" : "☆";
  }
}

function openList(mode) {
  listMode = mode;
  listTitle.textContent = mode === "saved" ? "Saved words" : "Recent searches";
  const words = mode === "saved" ? savedWords : historyWords;
  wordList.innerHTML = words.length
    ? words.map(word => `<button type="button" data-word="${cleanText(word)}"><span>${cleanText(word)}</span><small>Look up word →</small></button>`).join("")
    : '<p class="empty-list">Nothing here yet. Search for a word and it will appear here.</p>';
  listPanel.classList.remove("hidden");
  listPanel.scrollIntoView({ behavior: "smooth", block: "nearest" });
}

searchForm.addEventListener("submit", event => {
  event.preventDefault();
  searchWord(wordInput.value);
});

document.querySelectorAll(".example-word").forEach(button => {
  button.addEventListener("click", () => searchWord(button.dataset.word));
});

$("#savedToggle").addEventListener("click", () => openList("saved"));
$("#savedCardToggle").addEventListener("click", () => openList("saved"));
$("#historyToggle").addEventListener("click", () => openList("history"));
$("#closeList").addEventListener("click", () => listPanel.classList.add("hidden"));

wordList.addEventListener("click", event => {
  const button = event.target.closest("button[data-word]");
  if (button) searchWord(button.dataset.word);
});

showState("welcome");