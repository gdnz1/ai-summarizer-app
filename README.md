# ⚡ AI Text Summarizer (Enterprise & Showcase Edition)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Groq Cloud](https://img.shields.io/badge/Groq_Cloud-F05A28?style=for-the-badge&logo=fastapi&logoColor=white)](https://groq.com)
[![Meta Llama 3.3](https://img.shields.io/badge/Model-Llama_3.3_70B-blue?style=for-the-badge)](https://ai.meta.com/llama)
[![Material 3](https://img.shields.io/badge/Design-Material_3_Dark-7C3AED?style=for-the-badge)](https://m3.material.io)
[![Tests](https://img.shields.io/badge/Tests-Passing-success?style=for-the-badge)](test/)

A high-performance, cross-platform **Generative AI Text Summarization** application built with Flutter and powered by **Groq Cloud API** running Meta's flagship **Llama 3.3 70B** model. 

Designed with enterprise-grade software architecture, persona-driven **Prompt Engineering**, resilient error handling, and a sleek **Material 3 dark-themed** user interface.

---

## 🌟 Key Highlights

* 🚀 **Zero-Cost & Ultra-Low Latency Inference:** Powered by Groq's LPU™ (Language Processing Unit) inference engine, delivering sub-second token generation at zero cost (Free Tier).
* 🎯 **Persona-Driven Prompt Engineering:** Supports 3 specialized summarization modes tailored to distinct user needs (*Executive*, *Academic*, *Key Takeaways*).
* 🛡️ **Anti-Hallucination Guardrails:** System prompts strictly enforce ground-truth adherence, preventing model embellishment or unsupported extrapolation.
* 🌐 **Multilingual Intelligence:** Preserves and automatically mirrors the language of the source text (Turkish, English, German, etc.).
* 📋 **Streamlined UX:** One-click clipboard pasting, instant copy-to-clipboard, real-time word/character counters, and floating error notifications.
* 🔒 **Security Hygiene:** Zero hardcoded API secrets in version control; configured for runtime `--dart-define` key injection and `.env` environments.
* 🧪 **Automated Testing:** Covered by unit tests for prompt generation stability and widget tests for responsive UI validation.

---

## 🏗️ System Architecture

The project follows a clean separation of concerns dividing the presentation, domain configuration, and cloud inference layers:

```mermaid
flowchart TD
    subgraph UI ["Presentation Layer (Flutter / Material 3)"]
        Input["Multi-line TextField & Live Word/Char Counter"]
        ModeSelector["Interactive ModeSelectorBar (Executive / Academic / Bullets)"]
        ActionBtn["Summarize Action Button & Loading Indicator"]
        OutputCard["SummaryCard with SelectableText & Clipboard Copy"]
    end

    subgraph CoreEngine ["Domain & Service Layer"]
        Config["ApiConfig (dart-define & Key Validation)"]
        PromptEngine["PromptEngine (System Personas, Temperature & Guardrails)"]
        Service["GroqSummarizerService (HTTP, Timeouts & Error Mapping)"]
    end

    subgraph CloudInference ["Cloud GenAI Layer (Groq Cloud)"]
        GroqAPI["Groq Chat Completions API (TLS 1.3 / HTTPS)"]
        LlamaModel["Meta Llama 3.3 70B Versatile"]
    end

    Input --> ActionBtn
    ModeSelector --> PromptEngine
    ActionBtn --> Service
    Config --> Service
    PromptEngine --> Service
    Service -->|HTTPS POST (JSON)| GroqAPI
    GroqAPI --> LlamaModel
    LlamaModel -->|Inference Stream| GroqAPI
    GroqAPI -->|JSON Payload| Service
    Service --> OutputCard
```

---

## 🧠 Prompt Engineering Matrix

Rather than generic one-size-fits-all summarization, this project employs deliberate prompt engineering parameters:

| Mode | Target Persona | Temperature | Optimization Objective | Output Format |
| :--- | :--- | :---: | :--- | :--- |
| **Executive** | C-Level Briefing Analyst | `0.20` | Core impact, bottom-line takeaways, decision-making focus. | 2–3 concise sentences. |
| **Academic** | Research Scholar | `0.30` | Methodological accuracy, technical rigor, context preservation. | Structured scholarly narrative. |
| **Key Takeaways**| Strategic Knowledge Synthesizer | `0.25` | Quick scanning, high informational density. | 4–6 bolded bullet points. |

### Core System Directives
Every prompt pipeline includes universal constraint guardrails:
1. **Source Strictness:** Summaries must strictly derive from input text; no speculative hallucinations allowed.
2. **Language Parity:** Response language strictly matches source text language.
3. **Preamble Elimination:** Omits conversational filler ("*Here is your summary:*") for raw content delivery.

---

## 🚀 Quick Start Guide

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.9.2` or later)
* A free **Groq Cloud API Key** (Get yours at [console.groq.com/keys](https://console.groq.com/keys) in 30 seconds, no credit card required)

### 1. Clone the Repository
```bash
git clone https://github.com/gdnz1/ai-summarizer-app.git
cd ai-summarizer-app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Your API Key
You can run the app with your Groq API key via `--dart-define` (recommended for security):

```bash
flutter run -d chrome --dart-define=GROQ_API_KEY=gsk_your_actual_key_here
```

*Or optionally:* Replace the fallback placeholder in [lib/config/api_config.dart](lib/config/api_config.dart#L12) during local development.

---

## 🧪 Automated Testing

Run the test suite containing prompt generation unit tests and UI widget tests:

```bash
flutter test
```

Sample output:
```text
00:01 +5: All tests passed!
```

---

## 🔮 Future Roadmap (Computer Vision Integration)

This project was conceived as part of a Computer Vision curriculum. The planned next phase bridges **On-Device Computer Vision** with **Cloud LLMs**:

* 📷 **Google ML Kit OCR (`google_mlkit_text_recognition`):** Perform offline, on-device optical character recognition from camera snapshots or physical book/document scans.
* 📄 **Hybrid CV + NLP Pipeline:**
  1. Capture photo of physical document/slide.
  2. Extract raw text with on-device ML Kit NPU acceleration.
  3. Seamlessly pipe extracted text into Groq Llama 3.3 summarizer.
* 🎙️ **Speech-to-Text (Whisper):** Voice-activated audio lecture summarization.

---

## 📄 License
This project is open-source and available under the [MIT License](LICENSE).
