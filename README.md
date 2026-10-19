# ⚡ AI Text Summarizer (Hybrid Computer Vision & GenAI Edition)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Google ML Kit](https://img.shields.io/badge/Google_ML_Kit-OCR_Vision-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://developers.google.com/ml-kit/vision/text-recognition)
[![Groq Cloud](https://img.shields.io/badge/Groq_Cloud-LPU_Inference-F05A28?style=for-the-badge&logo=fastapi&logoColor=white)](https://groq.com)
[![OpenAI Open-Weights](https://img.shields.io/badge/Model-GPT_OSS_20B_%2F_120B-green?style=for-the-badge)](https://groq.com)
[![Material 3](https://img.shields.io/badge/Design-Material_3_Dark-7C3AED?style=for-the-badge)](https://m3.material.io)
[![Tests](https://img.shields.io/badge/Tests-Passing-success?style=for-the-badge)](test/)

A production-grade, cross-platform **Computer Vision + Generative AI** mobile application built with Flutter. 

Bridges **On-Device Machine Learning (Google ML Kit OCR)** with **Cloud LLM Inference (Groq Cloud Engine)** to capture, recognize, and synthesize text from camera snapshots, gallery images, or manual input in sub-second latency.

---

## 🌟 Key Highlights

* 📷 **On-Device Computer Vision (OCR):** Powered by Google ML Kit's Latin script text recognizer. Snaps photos directly via camera or imports from gallery to extract text with zero cloud cost, 100% offline, and zero API token consumption.
* 🚀 **Zero-Cost & Ultra-Low Latency Inference:** Connected to Groq's LPU™ (Language Processing Unit) running open-weights reasoning models (`openai/gpt-oss-20b` and `120b`), generating summaries in sub-second intervals.
* 🎯 **Persona-Driven Prompt Engineering:** Supports 3 specialized summarization modes tailored to distinct user needs (*Executive*, *Academic*, *Key Takeaways*).
* 🛡️ **Anti-Hallucination Guardrails:** System prompts strictly enforce ground-truth adherence, preventing model embellishment or unsupported extrapolation.
* 🌐 **Multilingual Intelligence:** Automatically detects and mirrors the language of the source text (Turkish, English, etc.).
* 📋 **Streamlined UX:** One-click clipboard pasting, instant copy-to-clipboard, real-time word/character counters, and floating error notifications.
* 🔒 **Security Hygiene:** Zero hardcoded API secrets in version control; configured for runtime `--dart-define-from-file=.env` key injection.
* 🧪 **Automated Testing:** Covered by unit tests for prompt generation stability and widget tests for responsive UI validation.

---

## 🏗️ System Architecture

```mermaid
flowchart TD
    subgraph ComputerVision ["On-Device Computer Vision Layer (Google ML Kit)"]
        CameraSource["Live Camera Snapshot"]
        GallerySource["Gallery Image Picker"]
        MLKitEngine["Google ML Kit TextRecognizer (On-Device NPU/CPU)"]
    end

    subgraph Presentation ["Presentation Layer (Flutter / Material 3)"]
        OcrSheet["OcrSourceSheet Modal"]
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
        LLM["OpenAI GPT OSS Reasoning Model (20B / 120B)"]
    end

    CameraSource --> OcrSheet
    GallerySource --> OcrSheet
    OcrSheet --> MLKitEngine
    MLKitEngine -->|Extracted Raw Text| Input

    Input --> ActionBtn
    ModeSelector --> PromptEngine
    ActionBtn --> Service
    Config --> Service
    PromptEngine --> Service
    Service -->|HTTPS POST (JSON)| GroqAPI
    GroqAPI --> LLM
    LLM -->|Inference Stream| GroqAPI
    GroqAPI -->|JSON Payload| Service
    Service --> OutputCard
```

---

## 🧠 Prompt Engineering Matrix

| Mode | Target Persona | Temperature | Optimization Objective | Output Format |
| :--- | :--- | :---: | :--- | :--- |
| **Executive** | C-Level Briefing Analyst | `0.20` | Core impact, bottom-line takeaways, decision-making focus. | 2–3 concise sentences. |
| **Academic** | Research Scholar | `0.30` | Methodological accuracy, technical rigor, context preservation. | Structured scholarly narrative & tables. |
| **Key Takeaways**| Strategic Knowledge Synthesizer | `0.25` | Quick scanning, high informational density. | 4–6 bolded bullet points. |

---

## 🚀 Quick Start Guide

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.9.2` or later)
* Free **Groq Cloud API Key** ([console.groq.com/keys](https://console.groq.com/keys))

### 1. Clone the Repository
```bash
git clone https://github.com/gdnz1/ai-summarizer-app.git
cd ai-summarizer-app
```

### 2. Configure Environment
Create a `.env` file based on `.env.example`:
```bash
cp .env.example .env
```
Add your Groq API key:
```env
GROQ_API_KEY=gsk_your_actual_key_here
GROQ_MODEL=openai/gpt-oss-20b
```

### 3. Run the App
```bash
# Web (Chrome)
flutter run -d chrome --dart-define-from-file=.env

# Android (With Live Camera OCR support)
flutter run -d android --dart-define-from-file=.env

# Build Android APK
flutter build apk --debug --dart-define-from-file=.env
```

---

## 🧪 Automated Testing

```bash
flutter test
```

---

## 🔮 Future Roadmap

* 📄 **Multi-page PDF Scanning:** Processing multi-page lecture slide decks into a single consolidated executive brief.
* 🎙️ **Audio-to-Text (Whisper):** Real-time voice note and lecture recording transcription.
* 🌐 **Offline LLM Integration:** Fallback to local on-device small language models (Gemma 2B / Llama 3.2 1B).

---

## 📄 License
This project is open-source and available under the [MIT License](LICENSE).
